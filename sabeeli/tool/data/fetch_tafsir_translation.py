"""Fetch Tafsir al-Muyassar (quran.com resource 16) and Saheeh International (resource 20)
into raw/, then build assets/quran/tafsir/ar_muyassar.json and en_sahih.json
(flat lists of 6236 strings in mushaf order). Only HTML tags / footnote markers are removed."""
import json, os, re, sys, time, urllib.request, html
HERE = os.path.dirname(os.path.abspath(__file__)); RAW = os.path.join(HERE, 'raw')
OUT = os.path.join(HERE, '..', '..', 'assets', 'quran', 'tafsir'); os.makedirs(OUT, exist_ok=True)
meta = json.load(open(os.path.join(HERE, '..', '..', 'assets', 'quran', 'meta.json'), encoding='utf-8'))
counts = [s['ayahs'] for s in meta['surahs']]

def get(url):
    for i in range(5):
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'sabeeli-data-builder'})
            return json.load(urllib.request.urlopen(req, timeout=60))
        except Exception as e:
            print('retry', url, e); time.sleep(2 + i * 3)
    raise SystemExit('failed ' + url)

raw_t = os.path.join(RAW, 'qc_tafsir16_all.json')
if not os.path.exists(raw_t):
    allv = {}
    for n in range(1, 115):
        page = 1
        while True:
            d = get(f'https://api.quran.com/api/v4/tafsirs/16/by_chapter/{n}?per_page=50&page={page}')
            for t in d['tafsirs']:
                allv[t['verse_key']] = t['text']
            p = d.get('pagination') or {}
            if p.get('next_page'): page = p['next_page']
            else: break
        print('surah', n, 'done', file=sys.stderr)
    json.dump(allv, open(raw_t, 'w', encoding='utf-8'), ensure_ascii=False)
tafsir = json.load(open(raw_t, encoding='utf-8'))

def clean_ar(s):
    s = re.sub(r'<[^>]+>', '', s or '')
    s = html.unescape(s)
    return re.sub(r'[ \t]+', ' ', s).strip()

# quran.com returns one entry per *group* of ayahs (e.g. 4:66 covers 4:66-68); the following
# ayahs of a group are absent. They get the same (duplicated) group text, so consecutive equal
# strings mean "one tafsir passage covering several ayahs".
ar = []; empty = []; grouped = []
for n, c in enumerate(counts, 1):
    for a in range(1, c + 1):
        k = f'{n}:{a}'
        if k in tafsir:
            t = clean_ar(tafsir[k])
        else:
            assert a > 1, k
            grouped.append(k); t = ar[-1]
        if not t: empty.append(k)
        ar.append(t)
print('muyassar ayahs sharing previous ayah group text:', len(grouped))
assert len(ar) == 6236
print('muyassar empty entries:', len(empty), empty[:20])
json.dump(ar, open(os.path.join(OUT, 'ar_muyassar.json'), 'w', encoding='utf-8', newline='\n'), ensure_ascii=False, separators=(',', ':'))

tr = json.load(open(os.path.join(RAW, 'qc_trans20.json'), encoding='utf-8'))['translations']
assert len(tr) == 6236
def clean_en(s):
    s = re.sub(r'<sup[^>]*>.*?</sup>', '', s)  # footnote markers
    s = re.sub(r'<[^>]+>', '', s)
    s = html.unescape(s)
    s = re.sub(r'\s+([,.;:!?])', r'\1', s)
    return re.sub(r'\s{2,}', ' ', s).strip()
en = [clean_en(t['text']) for t in tr]
assert all(en) and not any('<' in x or '>' in x for x in en)
json.dump(en, open(os.path.join(OUT, 'en_sahih.json'), 'w', encoding='utf-8', newline='\n'), ensure_ascii=False, separators=(',', ':'))
print('en sample', en[0], '|', en[6235])
print('ar sample', ar[0][:80], '|', ar[6235][:80])
