"""Build assets/hijri/ummalqura.json from the MIT-licensed hijridate package table
(github.com/dralshehri/hijridate, src/hijridate/ummalqura.py, MONTH_STARTS in Reduced Julian Day).
Stored as true Modified Julian Day: MJD = RJD - 1 (RJD = JDN - 2400000, MJD day 0 = 1858-11-17)."""
import ast, json, os, re, datetime
HERE = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(HERE, 'raw', 'hijri', 'ummalqura.py'), encoding='utf-8').read()
rjd = list(ast.literal_eval(re.search(r'MONTH_STARTS[^=]*=\s*(\([^)]*\))', src, re.S).group(1)))
offset = 1342 * 12
assert 'HIJRI_OFFSET: int = 1342 * 12' in src
start_year = 1343
assert len(rjd) == (1500 - 1343 + 1) * 12 + 1, len(rjd)
mjd = [r - 1 for r in rjd]
lens = [b - a for a, b in zip(mjd, mjd[1:])]
irregular = [(start_year + i // 12, i % 12 + 1, l) for i, l in enumerate(lens) if l not in (29, 30)]
# The source preserves a few historical (pre-1365 AH) official months of 28/31 days.
assert all(y < 1365 for y, _, _ in irregular), irregular
print('historical irregular month lengths (kept as in source):', irregular)
EPOCH = datetime.date(1858, 11, 17)
def h2g(y, m, d):
    return EPOCH + datetime.timedelta(days=mjd[(y - start_year) * 12 + (m - 1)] + d - 1)
checks = [((1447, 9, 1), datetime.date(2026, 2, 18)), ((1446, 1, 1), datetime.date(2024, 7, 7)),
          ((1445, 10, 1), datetime.date(2024, 4, 10)), ((1343, 1, 1), datetime.date(1924, 8, 1))]
for h, g in checks:
    print(h, '->', h2g(*h), 'expected', g, 'OK' if h2g(*h) == g else 'MISMATCH')
    assert h2g(*h) == g
out = {
    'source': 'hijridate (MIT) by Mohammed Alshehri - github.com/dralshehri/hijridate ummalqura.MONTH_STARTS',
    'startYear': start_year,
    'startMonthIndex': 0,
    'note': 'mjd[i] = Modified Julian Day of day 1 of Hijri month i, where i = (year - startYear) * 12 + (month - 1); '
            'mjd[0] = 1 Muharram 1343. The last element is the day after 30/29 Dhu al-Hijjah 1500 (end sentinel), '
            'so month length = mjd[i+1] - mjd[i]. Gregorian = DateTime.utc(1858, 11, 17) + mjd days. '
            'MJD = JDN - 2400001 = RJD - 1.',
    'endYear': 1500,
    'mjd': mjd,
}
os.makedirs(os.path.join(HERE, '..', '..', 'assets', 'hijri'), exist_ok=True)
with open(os.path.join(HERE, '..', '..', 'assets', 'hijri', 'ummalqura.json'), 'w', encoding='utf-8', newline='\n') as f:
    json.dump(out, f, separators=(',', ':'))
# dump month starts for cross-checking with .NET UmAlQuraCalendar
with open(os.path.join(HERE, 'raw', 'hijri', 'month_starts_iso.txt'), 'w') as f:
    for i, v in enumerate(mjd[:-1]):
        y, m = start_year + i // 12, i % 12 + 1
        f.write(f'{y} {m} {(EPOCH + datetime.timedelta(days=v)).isoformat()}\n')
print('entries', len(mjd), 'first', h2g(1343, 1, 1), 'end sentinel', EPOCH + datetime.timedelta(days=mjd[-1]))
