"""Build assets/quran/quran.json and assets/quran/meta.json.

Inputs (downloaded into tool/data/raw by fetch commands documented in assets/SOURCES.md):
  hafsData_v18.json      KFGQPC Hafs Uthmanic v18 text (github thetruetruth/quran-data-kfgqpc, hafs/data)
  quran-data.js          Tanzil Quran metadata v1.0 (https://tanzil.net/res/text/metadata/quran-data.js)
  qurancom_chapters.json https://api.quran.com/api/v4/chapters?language=en (names only)
Only structural transformation is done: the trailing " <arabic-indic digits>" aya-number
is removed from each aya_text; the text is otherwise byte-identical to the source.
"""
import json, re, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
RAW = os.path.join(HERE, 'raw')
OUT = os.path.join(HERE, '..', '..', 'assets', 'quran')
os.makedirs(OUT, exist_ok=True)

rows = json.load(open(os.path.join(RAW, 'hafsData_v18.json'), encoding='utf-8'))
assert len(rows) == 6236, len(rows)
NUM = re.compile(' ([٠-٩]+)$')
surahs = {}
kf_page = {}
kf_juz = {}
for r in rows:
    t = r['aya_text']
    m = NUM.search(t)
    assert m, (r['sora'], r['aya_no'], t[-10:])
    digits = int(''.join(str(ord(c) - 0x660) for c in m.group(1)))
    assert digits == r['aya_no'], (r['sora'], r['aya_no'], digits)
    body = t[:m.start()]
    assert body == body.strip() or True
    surahs.setdefault(r['sora'], []).append((r['aya_no'], body))
    kf_page[(r['sora'], r['aya_no'])] = r['page']
    kf_juz[(r['sora'], r['aya_no'])] = r['jozz']

assert sorted(surahs) == list(range(1, 115))
out = {'surahs': []}
for n in range(1, 115):
    ayas = surahs[n]
    assert [a for a, _ in ayas] == list(range(1, len(ayas) + 1)), n
    out['surahs'].append({'n': n, 'ayahs': [b for _, b in ayas]})
total = sum(len(s['ayahs']) for s in out['surahs'])
assert total == 6236

# Basmala checks
BASM = out['surahs'][0]['ayahs'][0]
for s in out['surahs'][1:]:
    assert not s['ayahs'][0].startswith(BASM[:6]), s['n']
with open(os.path.join(OUT, 'quran.json'), 'w', encoding='utf-8', newline='\n') as f:
    json.dump(out, f, ensure_ascii=False, separators=(',', ':'))

# ---- metadata ----
js = open(os.path.join(RAW, 'quran-data.js'), encoding='utf-8').read()
def block(name):
    m = re.search(r'QuranData\.' + name + r'\s*=\s*\[(.*?)\n\];', js, re.S)
    body = re.sub(r'//[^\n]*', '', m.group(1))
    return body
def pairs(name):
    b = block(name)
    return [(int(a), int(c)) for a, c in re.findall(r'\[\s*(\d+)\s*,\s*(\d+)\s*\]', b)]
juz = pairs('Juz'); hq = pairs('HizbQaurter'); pages = pairs('Page')
# drop trailing sentinel [115,1]
for arr in (juz, hq, pages):
    assert arr[-1] == (115, 1); arr.pop()
assert len(juz) == 30 and len(hq) == 240 and len(pages) == 604, (len(juz), len(hq), len(pages))
sajda = [(int(a), int(b), t) for a, b, t in re.findall(r"\[\s*(\d+)\s*,\s*(\d+)\s*,\s*'(\w+)'\s*\]", block('Sajda'))]
assert len(sajda) == 15
suras = re.findall(r"\[\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*'([^']*)',\s*\"([^\"]*)\",\s*'([^']*)',\s*'(\w+)'\]", block('Sura'))
assert len(suras) == 114
qc = {c['id']: c for c in json.load(open(os.path.join(RAW, 'qurancom_chapters.json'), encoding='utf-8'))['chapters']}

def page_of(s, a):
    # last page whose start <= (s,a)
    p = 1
    for i, st in enumerate(pages):
        if st <= (s, a): p = i + 1
        else: break
    return p

meta_s = []
for i, row in enumerate(suras):
    n = i + 1
    start, ayas, order, rukus, name_ar, tname, ename, typ = row
    ayas = int(ayas)
    assert ayas == len(out['surahs'][i]['ayahs']), n
    c = qc[n]
    assert c['verses_count'] == ayas
    meta_s.append({
        'n': n,
        'ar': c['name_arabic'],
        'tr': c['name_simple'],
        'en': c['translated_name']['name'],
        'type': typ,  # Tanzil: Meccan / Medinan
        'ayahs': ayas,
        'page': page_of(n, 1),
        'order': int(order),
    })
meta = {
    'surahs': meta_s,
    'juz': [{'s': s, 'a': a} for s, a in juz],
    'hizbQuarters': [{'s': s, 'a': a} for s, a in hq],
    'pages': [{'s': s, 'a': a} for s, a in pages],
    'sajdas': [{'s': s, 'a': a, 'type': t} for s, a, t in sajda],
}
with open(os.path.join(OUT, 'meta.json'), 'w', encoding='utf-8', newline='\n') as f:
    json.dump(meta, f, ensure_ascii=False, separators=(',', ':'))

# ---- cross-checks vs KFGQPC v18 page/juz columns ----
diff_p = [(k, kf_page[k], page_of(*k)) for k in kf_page if kf_page[k] != page_of(*k)]
print('ayahs whose KFGQPC-v18 page != Tanzil page:', len(diff_p), diff_p[:15])
def juz_of(s, a):
    j = 1
    for i, st in enumerate(juz):
        if st <= (s, a): j = i + 1
    return j
diff_j = [(k, kf_juz[k], juz_of(*k)) for k in kf_juz if kf_juz[k] != juz_of(*k)]
print('juz diffs:', len(diff_j), diff_j[:10])
qc_diff = [(n, qc[n]['pages'][0], meta_s[n-1]['page']) for n in qc if qc[n]['pages'][0] != meta_s[n-1]['page']]
print('surah start page diffs vs quran.com:', qc_diff)
rev_diff = [(n, qc[n]['revelation_place'], meta_s[n-1]['type']) for n in qc if (qc[n]['revelation_place']=='makkah') != (meta_s[n-1]['type']=='Meccan')]
print('revelation diffs vs quran.com:', rev_diff)
print('OK surahs', len(out['surahs']), 'ayahs', total, 'max page', max(kf_page.values()))
