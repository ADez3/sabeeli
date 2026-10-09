"""Build assets/azkar/azkar_ar.json and azkar_en.json.

Sources (raw copies in tool/data/raw):
  hisn/{ar,en}/{1..132}.json   hisnmuslim.com API (Hisn al-Muslim, Sa'id al-Qahtani) - text + REPEAT
  other/asellam_hisn.json      github.com/asellam/HisnElMuslim (MIT) - used ONLY for the "Reference"
                               citation of each item, attached by fuzzy matching of chapter+item text
  seen/{ar,en}.json            github.com/Seen-Arabic/Morning-And-Evening-Adhkar-DB (MIT) - separate
                               morning / evening lists with count, fadl (virtue), source (reference)
Hisn chapter 27 (combined morning & evening) is replaced by the two Seen-Arabic categories
(ids 1001 morning, 1002 evening). Texts are never edited, only whitespace-trimmed.

Fetch raw files first (see assets/SOURCES.md), e.g.:
  for i in $(seq 1 132); do for l in ar en; do curl -sSL http://www.hisnmuslim.com/api/$l/$i.json -o raw/hisn/$l/$i.json; done; done
"""
import json, os, re, difflib

HERE = os.path.dirname(os.path.abspath(__file__))
RAW = os.path.join(HERE, 'raw')
OUT = os.path.join(HERE, '..', '..', 'assets', 'azkar')
os.makedirs(OUT, exist_ok=True)
STR = r'"((?:[^"\\]|\\.)*)"'


def dec(s):
    return json.loads('"' + s + '"', strict=False)


def load_hisn(p):
    t = open(p, encoding='utf-8-sig').read()
    try:
        d = json.loads(t, strict=False)
        return list(d.keys())[0], list(d.values())[0]
    except json.JSONDecodeError:
        # a few hisnmuslim.com files are malformed (e.g. missing quote after the title);
        # fall back to field-wise regex extraction of the regular per-item layout.
        items = []
        pat = (r'"ID"\s*:\s*(\d+)\s*,\s*"ARABIC_TEXT"\s*:\s*' + STR +
               r'\s*,\s*"LANGUAGE_ARABIC_TRANSLATED_TEXT"\s*:\s*' + STR +
               r'\s*,\s*"TRANSLATED_TEXT"\s*:\s*' + STR + r'\s*,\s*"REPEAT"\s*:\s*(\d+)')
        for m in re.finditer(pat, t, re.S):
            items.append({'ID': int(m.group(1)), 'ARABIC_TEXT': dec(m.group(2)),
                          'LANGUAGE_ARABIC_TRANSLATED_TEXT': dec(m.group(3)),
                          'TRANSLATED_TEXT': dec(m.group(4)), 'REPEAT': int(m.group(5))})
        assert items, p
        assert len(items) == t.count('"ID"'), p
        print('  regex-parsed malformed file', p[-12:], len(items))
        return None, items


def norm(s):
    s = re.sub(r'[ً-ْٰـۡ]', '', s or '')
    s = s.replace('أ', 'ا').replace('إ', 'ا').replace('آ', 'ا').replace('ى', 'ي').replace('ة', 'ه')
    return re.sub(r'[^ء-ي]+', ' ', s).strip()


def sim(a, b):
    return difflib.SequenceMatcher(None, norm(a)[:400], norm(b)[:400], autojunk=False).ratio()


KEYS = {1: 'waking', 2: 'dressing', 3: 'new_clothes', 5: 'undressing', 6: 'restroom_entering',
        7: 'restroom_leaving', 8: 'wudu', 9: 'wudu_after', 10: 'leaving_home', 11: 'entering_home',
        12: 'going_to_mosque', 13: 'mosque_entering', 14: 'mosque_leaving', 15: 'adhan',
        16: 'prayer_opening', 17: 'ruku', 18: 'rising_from_ruku', 19: 'sujood', 20: 'between_sujood',
        21: 'tilawah_sujood', 22: 'tashahhud', 23: 'salawat_tashahhud', 24: 'before_salam',
        25: 'after_prayer', 26: 'istikhara', 28: 'sleep', 29: 'turning_at_night', 30: 'fear_in_sleep',
        31: 'bad_dream', 32: 'qunut_witr', 33: 'after_witr', 34: 'worry_grief', 35: 'distress',
        41: 'debt', 44: 'after_sin', 49: 'visiting_sick', 53: 'calamity', 55: 'funeral_prayer',
        57: 'condolence', 60: 'visiting_graves', 61: 'wind', 62: 'thunder', 63: 'rain_seeking',
        64: 'rain', 67: 'new_moon', 68: 'breaking_fast', 69: 'food', 70: 'after_eating',
        77: 'sneezing', 82: 'anger', 85: 'kaffarat_majlis', 95: 'riding', 96: 'travel', 98: 'market',
        105: 'returning_from_travel', 129: 'istighfar', 130: 'tasbih'}

idx_ar = load_hisn(os.path.join(RAW, 'hisn', 'husn_ar.json'))[1]
idx_en = load_hisn(os.path.join(RAW, 'hisn', 'husn_en.json'))[1]
title_ar = {c['ID']: c['TITLE'].strip() for c in idx_ar}
title_en = {c['ID']: c['TITLE'].strip() for c in idx_en}
order = [c['ID'] for c in idx_ar]  # hisnmuslim.com display order (27, 28, 1, 6, ...)
assert sorted(order) == list(range(1, 133))

asellam = json.load(open(os.path.join(RAW, 'other', 'asellam_hisn.json'), encoding='utf-8-sig'))
as_chapters = [(t, v['Adhkar']) for t, v in asellam.items()]


def seen(lang):
    return json.load(open(os.path.join(RAW, 'seen', lang + '.json'), encoding='utf-8'))


s_ar, s_en = seen('ar'), seen('en')
assert len(s_ar) == len(s_en)


def seen_cat(cid, key, types, t_ar, t_en):
    ar_items, en_items = [], []
    for a, e in zip(s_ar, s_en):
        assert a['order'] == e['order'] and a['count'] == e['count'] and a['type'] == e['type']
        if a['type'] in types:
            ar_items.append({'id': cid * 100 + a['order'], 'text': a['content'].strip(),
                             'count': int(a['count'] or 1), 'reference': a['source'].strip(),
                             'virtue': a['fadl'].strip()})
            en_items.append({'id': cid * 100 + a['order'], 'text': e['translation'].strip(),
                             'arabic': e['content'].strip(),
                             'transliteration': (e.get('transliteration') or '').strip(),
                             'count': int(e['count'] or 1), 'reference': e['source'].strip(),
                             'virtue': e['fadl'].strip()})
    return ({'id': cid, 'key': key, 'title': t_ar, 'items': ar_items},
            {'id': cid, 'key': key, 'title': t_en, 'items': en_items})


m_ar, m_en = seen_cat(1001, 'morning', (0, 1), 'أذكار الصباح', 'Morning remembrances')
e_ar, e_en = seen_cat(1002, 'evening', (0, 2), 'أذكار المساء', 'Evening remembrances')
cats_ar, cats_en = [m_ar, e_ar], [m_en, e_en]

ref_hits = ref_total = 0
for cid in order:
    if cid == 27:
        continue
    _, ar = load_hisn(os.path.join(RAW, 'hisn', 'ar', f'{cid}.json'))
    _, en = load_hisn(os.path.join(RAW, 'hisn', 'en', f'{cid}.json'))
    assert [x['ID'] for x in ar] == [x['ID'] for x in en], cid
    best = max(as_chapters, key=lambda c: sim(c[0], title_ar[cid]))
    title_ok = sim(best[0], title_ar[cid]) > 0.6
    items_ar, items_en = [], []
    for a, e in zip(ar, en):
        ref = ''
        if title_ok and best[1]:
            cand = max(best[1], key=lambda x: sim(x['Text'], a['ARABIC_TEXT']))
            if sim(cand['Text'], a['ARABIC_TEXT']) > 0.6:
                ref = (cand.get('Reference') or '').strip()
        ref_total += 1
        ref_hits += bool(ref)
        cnt = int(a.get('REPEAT') or 1)
        items_ar.append({'id': a['ID'], 'text': a['ARABIC_TEXT'].strip(), 'count': cnt,
                         'reference': ref, 'virtue': ''})
        items_en.append({'id': e['ID'], 'text': (e.get('TRANSLATED_TEXT') or '').strip(),
                         'arabic': a['ARABIC_TEXT'].strip(),  # Arabic always from the ar file (same ID)
                         'transliteration': (e.get('LANGUAGE_ARABIC_TRANSLATED_TEXT') or '').strip(),
                         'count': cnt, 'reference': ref, 'virtue': ''})
    cats_ar.append({'id': cid, 'key': KEYS.get(cid), 'title': title_ar[cid], 'items': items_ar})
    cats_en.append({'id': cid, 'key': KEYS.get(cid), 'title': title_en[cid], 'items': items_en})

for name, cats in (('azkar_ar.json', cats_ar), ('azkar_en.json', cats_en)):
    with open(os.path.join(OUT, name), 'w', encoding='utf-8', newline='\n') as f:
        json.dump({'categories': cats}, f, ensure_ascii=False, separators=(',', ':'))
print('categories', len(cats_ar), 'items', sum(len(c['items']) for c in cats_ar))
print('hisn items with reference attached:', ref_hits, '/', ref_total)
print('empty en text:', [(c['id'], i['id']) for c in cats_en for i in c['items'] if not i['text']])
for c in cats_ar:
    if c['key'] in ('morning', 'evening', 'after_prayer', 'sleep', 'waking'):
        print(c['key'], len(c['items']), [i['count'] for i in c['items']])
