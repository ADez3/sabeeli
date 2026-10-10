"""Builds assets/azkar/after_prayer.json: the adhkar said after the obligatory
prayers, as a guided sequence of steps.

Every dhikr text is cut verbatim out of the bundled Hisn al-Muslim files
(assets/azkar/azkar_ar.json / azkar_en.json, category 25), so nothing is retyped
by hand. Entries that bundle several adhkar ("Astaghfirullah (three times), then
Allahumma anta as-salam…", "SubhanAllah, Alhamdulillah, Allahu akbar (33 times)…")
are split into one step each, so they can be counted on the misbaha. The Quran
passages (Ayat al-Kursi and the three Quls) are referenced by surah and ayah
instead, so the app renders them from the mushaf text in the reader's riwayah.

Run from sabeeli/:  python tool/data/build_after_prayer.py
"""

import json
import re

AR = 'assets/azkar/azkar_ar.json'
EN = 'assets/azkar/azkar_en.json'
OUT = 'assets/azkar/after_prayer.json'


def items(path):
    cats = json.load(open(path, encoding='utf8'))['categories']
    cat = next(c for c in cats if c['id'] == 25)
    return {i['id']: i for i in cat['items']}


ar = items(AR)
en = items(EN)

# Split the bundled entries on their punctuation; the words are left untouched.
_istighfar, _salam = re.fullmatch(
    r'\(\((.*?) \(.*?\) (.*)\)\)\.?', ar[66]['text']).groups()
_subhan, _hamd, _akbar, _tahlil = re.fullmatch(
    r'\(\((.*?)، (.*?)، (.*?) \(.*?\) (.*)\)\)\.?', ar[69]['text']).groups()


def unwrap(text):
    """Drops Hisn's (( )) quote marks and trailing instructions."""
    text = text.strip()
    if text.startswith('(('):
        text = text[2:text.index('))')]
    return text.strip(' ،,.')


def tidy(s):
    return re.sub(r'\s+', ' ', s).strip()


steps = [
    {
        'id': 'istighfar',
        'arabic': _istighfar,
        'count': 3,
        'transliteration': 'Astaghfirullah',
        'translation': 'I ask Allah for forgiveness.',
        'reference': ar[66]['reference'],
    },
    {
        'id': 'anta_as_salam',
        'arabic': _salam,
        'count': 1,
        'transliteration': 'Allahumma antas-salam waminkas-salam, tabarakta ya dhal-jalali wal-ikram.',
        'translation': 'O Allah, You are As-Salam and from You is all peace, blessed are You, O Possessor of majesty and honour.',
        'reference': ar[66]['reference'],
    },
    {
        'id': 'la_mani',
        'arabic': unwrap(ar[67]['text']),
        'count': 1,
        'transliteration': tidy(en[67]['transliteration'].strip('()')),
        'translation': tidy(en[67]['text'].strip('()')),
        'reference': ar[67]['reference'],
    },
    {
        'id': 'lahu_an_nima',
        'arabic': unwrap(ar[68]['text']),
        'count': 1,
        'transliteration': tidy(en[68]['transliteration'].strip('()')),
        'translation': tidy(en[68]['text'].strip('()')),
        'reference': ar[68]['reference'],
    },
    {
        'id': 'subhanallah',
        'arabic': _subhan,
        'count': 33,
        'transliteration': 'SubhanAllah',
        'translation': 'How perfect Allah is.',
        'reference': 'مسلم 1/ 418',
    },
    {
        'id': 'alhamdulillah',
        'arabic': _hamd.removeprefix('وَ'),
        'count': 33,
        'transliteration': 'Alhamdulillah',
        'translation': 'All praise is for Allah.',
        'reference': 'مسلم 1/ 418',
    },
    {
        'id': 'allahu_akbar',
        'arabic': _akbar.removeprefix('وَ'),
        'count': 33,
        'transliteration': 'Allahu akbar',
        'translation': 'Allah is the greatest.',
        'reference': 'مسلم 1/ 418',
    },
    {
        'id': 'tahlil_hundred',
        'arabic': _tahlil,
        'count': 1,
        'transliteration': 'La ilaha illal-lahu wahdahu la shareeka lah, lahul-mulku walahul-hamd, wahuwa AAala kulli shayin qadeer.',
        'translation': 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.',
        # Muslim 597: the hundredth, completing the tasbih.
        'virtue': 'من قال ذلك دبر كل صلاة غفرت خطاياه وإن كانت مثل زبد البحر',
        'reference': 'مسلم 1/ 418',
    },
    # The Quls: once after every prayer, three times after Fajr and Maghrib.
    {'id': 'ikhlas', 'quran': [112, 1, 4], 'count': 1, 'countFajrMaghrib': 3,
     'reference': ar[70]['reference']},
    {'id': 'falaq', 'quran': [113, 1, 5], 'count': 1, 'countFajrMaghrib': 3,
     'reference': ar[70]['reference']},
    {'id': 'nas', 'quran': [114, 1, 6], 'count': 1, 'countFajrMaghrib': 3,
     'reference': ar[70]['reference']},
    {'id': 'ayat_al_kursi', 'quran': [2, 255, 255], 'count': 1,
     'virtue': ar[71]['reference'].split(' .')[0].strip(),
     'reference': ar[71]['reference'].split(' .')[1].strip().removeprefix('و')},
    {
        'id': 'yuhyi_wa_yumit',
        'arabic': unwrap(ar[72]['text']),
        'count': 10,
        'only': ['fajr', 'maghrib'],
        'transliteration': 'La ilaha illal-lahu wahdahu la shareeka lah, lahul-mulku walahul-hamd, yuhyee wayumeet, wahuwa AAala kulli shayin qadeer.',
        'translation': 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise, He gives life and causes death and He is over all things omnipotent.',
        'reference': ar[72]['reference'],
    },
    {
        'id': 'ilman_nafia',
        'arabic': unwrap(ar[73]['text']),
        'count': 1,
        'only': ['fajr'],
        'transliteration': 'Allahumma innee as-aluka AAilman nafiAAan, warizqan tayyiban, waAAamalan mutaqabbalan.',
        'translation': 'O Allah, I ask You for knowledge which is beneficial and sustenance which is good, and deeds which are acceptable.',
        'reference': ar[73]['reference'],
    },
]

for s in steps:
    if 'arabic' in s:
        # Every text must still be found, word for word, in the source.
        source = ' '.join(i['text'] for i in ar.values())
        assert s['arabic'] in source, s['id']

json.dump({'steps': steps}, open(OUT, 'w', encoding='utf8'),
          ensure_ascii=False, indent=1)
for s in steps:
    print(s['id'], s['count'], s.get('arabic', s.get('quran')))
