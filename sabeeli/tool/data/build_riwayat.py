"""Build the data for the additional Qur'an riwayat (Warsh, Qalun, ...).

For every entry of RIWAYAT this writes, into assets/quran/riwayat/<id>/:
  quran.json     {"surahs":[{"n":1,"ayahs":[...]}, ...]}  same shape as assets/quran/quran.json
  meta.json      surah ayah counts/start pages, page and juz starts, sajdas, basmala text
  hafs_map.json  {"toHafs":[[...], ...]}  for each ayah of the riwayah (mushaf order), the
                 0-based flat indices of the Hafs ayahs (assets/quran/quran.json) it overlaps

Inputs: the official KFGQPC "Uthmanic <riwayah> v2.x" developer packages, unzipped by
tool/data/fetch_raw.sh into tool/data/raw/riwayat/<id>/.

The Qur'an text is never edited. The only structural changes are:
  * the trailing U+00A0 + ayah-number glyph (one code point U+FC00 + n-1, drawn by the
    KFGQPC font) is removed; it is checked against aya_no first;
  * U+200F (RLM) / U+200D (ZWJ) characters, which are export artifacts, are removed;
  * leading/trailing whitespace is trimmed.
Run from sabeeli/:  python tool/data/build_riwayat.py
"""
import difflib
import json
import os
import re
import sys
import unicodedata

HERE = os.path.dirname(os.path.abspath(__file__))
RAW = os.path.join(HERE, 'raw', 'riwayat')
ASSETS = os.path.join(HERE, '..', '..', 'assets')
HAFS = os.path.join(ASSETS, 'quran', 'quran.json')

# Add a riwayah by adding an entry here (and its download to fetch_raw.sh).
RIWAYAT = [
    {
        'id': 'warsh',
        'data': 'UthmanicWarsh_v2-1 data/warshData_v2-1.json',
        'font': 'UthmanicWarsh_V21.ttf',
    },
    {
        'id': 'qalun',
        'data': 'UthmanicQaloun_v2-1 data/QalounData_v2-1.json',
        'font': 'UthmanicQaloun_V21.ttf',
    },
]

# NBSP is optional: at least one record (Warsh 16:123) has the glyph glued to the last word.
AYAH_GLYPH = re.compile(' ?([ﰀ-ﴝ])$')
ARTIFACTS = re.compile('[‍‏]')
SAJDA = '۩'


def say(*a):
    print(*a, flush=True)


# ---------------------------------------------------------------- text

def load_records(rid, rel):
    # The packages are UTF-8 with BOM.
    with open(os.path.join(RAW, rid, rel), encoding='utf-8-sig') as f:
        rows = json.load(f)
    rows.sort(key=lambda r: r['id'])
    out = []
    for r in rows:
        t = r['aya_text']
        m = AYAH_GLYPH.search(t)
        assert m, (rid, r['sura_no'], r['aya_no'], t[-10:])
        n = ord(m.group(1)) - 0xFC00 + 1
        assert n == r['aya_no'], (rid, r['sura_no'], r['aya_no'], n)
        body = ARTIFACTS.sub('', t[:m.start()]).strip()
        # A leftover private glyph would mean the number pattern was not where we expect.
        assert not re.search('[ﰀ-﷿]', body), (rid, r['sura_no'], r['aya_no'])
        out.append({
            's': r['sura_no'],
            'a': r['aya_no'],
            'text': body,
            # "85-86": the ayah starts on page 85 and ends on 86.
            'page': int(str(r['page']).split('-')[0]),
            'page_end': int(str(r['page']).split('-')[-1]),
            'juz': int(r['jozz']),
        })
    return out


def build_surahs(recs):
    surahs = {}
    for r in recs:
        surahs.setdefault(r['s'], []).append(r)
    assert sorted(surahs) == list(range(1, 115))
    for n, ayahs in surahs.items():
        assert [r['a'] for r in ayahs] == list(range(1, len(ayahs) + 1)), n
    return [surahs[n] for n in range(1, 115)]


# ---------------------------------------------------------------- word normalisation

FOLD = str.maketrans({
    'ٱ': 'ا', 'أ': 'ا', 'إ': 'ا', 'آ': 'ا',
    'ى': 'ي', 'ے': 'ي', 'ئ': 'ي',  # yeh variants (incl. Warsh yeh barree)
    'ة': 'ه', 'ؤ': 'و',
    'ء': None, 'ـ': None, 'ٰ': None,
})


def norm_word(w):
    """Skeleton of a word for comparing spellings across riwayat.

    Drops every diacritic, Qur'anic annotation sign (U+06D6..U+06ED, which also covers
    the small waw/yeh U+06E5/U+06E6 used for vowel lengthening in Warsh/Qalun), tatweel
    and dagger alef, and folds hamza carriers and yeh/teh-marbuta variants together.
    Long alef is dropped as well: the riwayat often write a dagger alef where the Hafs
    text has a full one (عَيْنَٰنِ / عَيۡنَانِ).
    """
    w = ''.join(c for c in w
                if unicodedata.category(c) not in ('Mn', 'Me') and not 'ۖ' <= c <= 'ۭ')
    w = w.translate(FOLD).replace('ا', '')
    # Tokens that are only pause marks, ۞, ۩ or digits normalise to nothing Arabic.
    return w if re.search('[ء-ي]', w) else ''


def words(text):
    return [n for n in (norm_word(t) for t in text.split()) if n]


# ---------------------------------------------------------------- alignment to Hafs

def align_surah(hafs_ayahs, hafs_base, riw_ayahs, riw_base):
    """Return {riwayah flat index: set(hafs flat indices)} for one surah."""
    hw, ha = [], []
    for i, t in enumerate(hafs_ayahs):
        for w in words(t):
            hw.append(w)
            ha.append(hafs_base + i)
    rw, ra = [], []
    for i, t in enumerate(riw_ayahs):
        for w in words(t):
            rw.append(w)
            ra.append(riw_base + i)
    target = [None] * len(rw)
    sm = difflib.SequenceMatcher(None, hw, rw, autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            for k in range(j2 - j1):
                target[j1 + k] = ha[i1 + k]
        elif tag == 'replace':
            # Spread the riwayah words proportionally over the Hafs words of the block.
            for k in range(j2 - j1):
                target[j1 + k] = ha[i1 + (k * (i2 - i1)) // (j2 - j1)]
        elif tag == 'insert':
            # Words with no Hafs counterpart: nearest Hafs word on either side.
            for k in range(j2 - j1):
                target[j1 + k] = ha[i1 - 1] if i1 > 0 else ha[min(i1, len(ha) - 1)]
        # 'delete': Hafs-only words; they show up in the coverage report if they matter.
    res = {riw_base + i: set() for i in range(len(riw_ayahs))}
    for a, h in zip(ra, target):
        res[a].add(h)
    return res


def build_map(rid, surahs, hafs):
    total = []
    hafs_base = riw_base = 0
    for n in range(1, 115):
        hs = hafs['surahs'][n - 1]['ayahs']
        rs = [r['text'] for r in surahs[n - 1]]
        m = align_surah(hs, hafs_base, rs, riw_base)
        for i in range(len(rs)):
            assert m[riw_base + i], (rid, n, i + 1, 'unmapped ayah')
            total.append(sorted(m[riw_base + i]))
        hafs_base += len(hs)
        riw_base += len(rs)
    return total


def check_map(rid, to_hafs, surahs, hafs):
    hafs_flat = []
    for s in hafs['surahs']:
        hafs_flat += [(s['n'], i + 1) for i in range(len(s['ayahs']))]
    riw_flat = [(r['s'], r['a']) for s in surahs for r in s]
    covered = set(h for hs in to_hafs for h in hs)
    missing = [hafs_flat[i] for i in range(len(hafs_flat)) if i not in covered]
    say(f'  [{rid}] Hafs ayahs not covered: {missing}')
    bad_order = [riw_flat[i] for i in range(1, len(to_hafs)) if to_hafs[i][0] < to_hafs[i - 1][-1]]
    say(f'  [{rid}] non-monotonic: {bad_order}')
    gaps = [riw_flat[i] for i, hs in enumerate(to_hafs) if hs != list(range(hs[0], hs[-1] + 1))]
    say(f'  [{rid}] non-contiguous: {gaps}')
    wide = [(riw_flat[i], hs) for i, hs in enumerate(to_hafs) if len(hs) > 2]
    say(f'  [{rid}] ayahs overlapping >2 Hafs ayahs: {wide}')

    def at(s, a):
        return to_hafs[riw_flat.index((s, a))]
    checks = [
        ('1:1 -> Hafs 1:2', at(1, 1) == [1]),
        ('2:1 -> Hafs 2:1+2:2', at(2, 1) == [7, 8]),
        ('2:253 and 2:254 -> Hafs 2:255 (261)', at(2, 253) == [261] and at(2, 254) == [261]),
        ('surah 112 1:1', [at(112, a) for a in range(1, 5)]
         == [[hafs_flat.index((112, a))] for a in range(1, 5)]),
    ]
    for label, ok in checks:
        say(f'  [{rid}] {"OK  " if ok else "FAIL"} {label}')
    diffs = [(s['n'], len(s['ayahs']), len(surahs[s['n'] - 1]))
             for s in hafs['surahs'] if len(s['ayahs']) != len(surahs[s['n'] - 1])]
    say(f'  [{rid}] surahs whose count differs from Hafs (n, hafs, riwayah): {diffs}')
    return all(ok for _, ok in checks)


# ---------------------------------------------------------------- meta

def find_basmala(text):
    """Cut the basmala out of 27:30 exactly as this riwayah spells it."""
    start = re.search('(?:^|\\s)(بِس)', text).start(1)
    pos = start
    for tok in re.finditer('\\S+', text[start:]):
        pos = start + tok.end()
        if norm_word(tok.group()) == norm_word('الرحيم'):
            break
    else:
        raise AssertionError('no basmala end in 27:30')
    b = text[start:pos]
    assert b in text and words(b) == words('بسم الله الرحمن الرحيم'), b
    return b


def build_meta(rid, surahs, recs):
    meta = {'surahs': [{'n': s[0]['s'], 'ayahs': len(s), 'page': s[0]['page']} for s in surahs]}

    first_on = {}
    for r in recs:
        first_on.setdefault(r['page'], r)
    pages = []
    for p in range(1, 605):
        r = first_on.get(p)
        if r is None:
            # No ayah starts here: use the ayah running over from the previous page.
            r = [x for x in recs if x['page'] < p <= x['page_end']][0]
            say(f'  [{rid}] page {p} has no ayah start; using spanning {r["s"]}:{r["a"]}')
        pages.append({'s': r['s'], 'a': r['a']})
    assert max(r['page_end'] for r in recs) == 604
    meta['pages'] = pages

    first_juz = {}
    for r in recs:
        first_juz.setdefault(r['juz'], r)
    assert sorted(first_juz) == list(range(1, 31))
    meta['juz'] = [{'s': first_juz[j]['s'], 'a': first_juz[j]['a']} for j in range(1, 31)]

    # Hizb quarters cannot be derived reliably from these records (۞ also marks eighths
    # in some riwayat and is sometimes placed mid-ayah), so none are provided.
    meta['hizbQuarters'] = []
    meta['sajdas'] = [{'s': r['s'], 'a': r['a'], 'type': 'recommended'}
                      for r in recs if SAJDA in r['text']]
    meta['basmala'] = find_basmala(surahs[26][29]['text'])
    return meta


# ---------------------------------------------------------------- output

def dump(obj, *path):
    p = os.path.join(*path)
    with open(p, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(obj, f, ensure_ascii=False, separators=(',', ':'))
    say(f'  wrote {os.path.relpath(p, os.path.join(HERE, "..", ".."))} ({os.path.getsize(p):,} bytes)')


def check_font(name):
    """Optional: make sure the bundled font has the characters the app relies on."""
    try:
        from fontTools.ttLib import TTFont
    except ImportError:
        say('  (fontTools not installed, font check skipped)')
        return
    p = os.path.join(ASSETS, 'fonts', name)
    if not os.path.exists(p):
        say(f'  font {name} not found (copied by fetch_raw.sh)')
        return
    cmap = TTFont(p).getBestCmap()
    for cp in (0x00A0, 0xFD3E, 0xFD3F, 0x06DE, 0x06E9, 0xFC00):
        say(f'  {name}: U+{cp:04X} {"present" if cp in cmap else "MISSING"}')


def main():
    with open(HAFS, encoding='utf-8') as f:
        hafs = json.load(f)
    ok = True
    for cfg in RIWAYAT:
        rid = cfg['id']
        say(f'== {rid}')
        recs = load_records(rid, cfg['data'])
        surahs = build_surahs(recs)
        say(f'  {len(recs)} ayahs')
        out = os.path.join(ASSETS, 'quran', 'riwayat', rid)
        os.makedirs(out, exist_ok=True)

        dump({'surahs': [{'n': i + 1, 'ayahs': [r['text'] for r in s]} for i, s in enumerate(surahs)]},
             out, 'quran.json')

        meta = build_meta(rid, surahs, recs)
        say(f'  sajdas ({len(meta["sajdas"])}): {[(x["s"], x["a"]) for x in meta["sajdas"]]}')
        say(f'  basmala: {meta["basmala"]}')
        dump(meta, out, 'meta.json')

        to_hafs = build_map(rid, surahs, hafs)
        assert len(to_hafs) == len(recs)
        ok &= check_map(rid, to_hafs, surahs, hafs)
        dump({'toHafs': to_hafs}, out, 'hafs_map.json')

        check_font(cfg['font'])
    if not ok:
        sys.exit('spot checks failed')


if __name__ == '__main__':
    main()
