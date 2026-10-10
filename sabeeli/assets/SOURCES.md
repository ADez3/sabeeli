# Bundled data sources and licenses

All files were downloaded from the sources below and only transformed structurally
(JSON reshaping, HTML-tag removal). No Qur'an, hadith or dhikr text was typed or edited by hand.
Reproduce with `tool/data/fetch_raw.sh` followed by the `tool/data/build_*.py` scripts
(see the header of `fetch_raw.sh`). Raw downloads live in `tool/data/raw/` (git-ignored).

## Qur'an

| File | Source | License / attribution |
|---|---|---|
| `quran/quran.json` | King Fahd Glorious Qur'an Printing Complex (KFGQPC), *Hafs Uthmanic data v18* (`hafsData_v18.json`, 2021-10-25), official package from https://qurancomplex.gov.sa/en/techquran/dev/ , mirror https://github.com/thetruetruth/quran-data-kfgqpc (`hafs/data/hafsData_v18.json`) | (c) KFGQPC. Free use and distribution; text must not be altered. Only change made: the trailing `U+00A0 + Arabic-Indic aya number` was removed from every `aya_text`. |
| `fonts/UthmanicHafs_V18.ttf` | KFGQPC *Uthmanic Hafs* font v0.18 ("KFGQPC HAFS Uthmanic Script", file `hafs.18.ttf` in the same mirror) | KFGQPC EULA, see `fonts/LICENSE-UthmanicHafs.txt`: free to use, copy, distribute; must not be sold, modified, or reverse engineered. |
| `quran/meta.json` | Tanzil Quran Metadata v1.0, https://tanzil.net/res/text/metadata/quran-data.js (juz, hizb quarters, 604 pages, sajdas, revelation type, revelation order); surah names (Arabic/simple transliteration/English meaning) from https://api.quran.com/api/v4/chapters?language=en | Tanzil metadata: Creative Commons Attribution 3.0, attribution "Tanzil.net". Surah names: Quran.com (Quran.Foundation). |
| `quran/tafsir/ar_muyassar.json` | Al-Tafsir al-Muyassar (KFGQPC), via Quran.com API v4 resource 16 (`/tafsirs/16/by_chapter/{n}`) | (c) King Fahd Complex. Attribution: "التفسير الميسر - مجمع الملك فهد لطباعة المصحف الشريف". HTML tags removed. |
| `quran/tafsir/en_sahih.json` | Saheeh International translation, via Quran.com API v4 resource 20 (`/quran/translations/20`) | (c) Saheeh International (Al-Muntada Al-Islami / Abul-Qasim Publishing House). Attribution "Saheeh International". Footnote markers (`<sup>`) removed. |
| `quran/translations_catalog.json` | Catalog of on-demand editions of https://github.com/fawazahmed0/quran-api (served via jsDelivr) | quran-api is released under The Unlicense; each translation keeps its own author's rights (author is listed per entry). |

## Azkar (Hisn al-Muslim)

| File | Source | License / attribution |
|---|---|---|
| `azkar/azkar_ar.json`, `azkar/azkar_en.json` (all categories except morning/evening) | Hisn al-Muslim (*Fortress of the Muslim*) by Sa'id ibn Wahf al-Qahtani, via the hisnmuslim.com API (`http://www.hisnmuslim.com/api/{ar,en}/husn_{ar,en}.json` and `/api/{ar,en}/{1..132}.json`): Arabic text, English translation, transliteration, repeat counts | The author allows the book to be printed and distributed free of charge. Attribution: "حصن المسلم - سعيد بن علي بن وهف القحطاني", hisnmuslim.com. |
| `reference` field of those categories | https://github.com/asellam/HisnElMuslim (`hisn.json`), matched to hisnmuslim.com items by text similarity | MIT License (c) asellam. |
| Morning (`id 1001`) and evening (`id 1002`) categories | https://github.com/Seen-Arabic/Morning-And-Evening-Adhkar-DB (`ar.json`, `en.json`): text, count, virtue (`fadl`), reference (`source`), English translation and transliteration | MIT License, Copyright (c) 2024 Seen Arabic. |

## Hijri calendar

| File | Source | License |
|---|---|---|
| `hijri/ummalqura.json` | `MONTH_STARTS` table of the *hijridate* package (formerly hijri-converter) by Mohammed Alshehri, https://github.com/dralshehri/hijridate/blob/main/src/hijridate/ummalqura.py. Converted from Reduced Julian Day to Modified Julian Day (MJD = RJD - 1). | MIT License, Copyright (c) Mohammed Alshehri |

## Fonts

| File | Source | License |
|---|---|---|
| `fonts/IBMPlexSansArabic-{Regular,Medium,SemiBold,Bold}.ttf` | https://github.com/google/fonts/tree/main/ofl/ibmplexsansarabic | SIL Open Font License 1.1, see `fonts/OFL-IBMPlexSansArabic.txt` (Copyright 2017 IBM Corp., Reserved Font Name "Plex") |
| `fonts/Amiri-{Regular,Bold}.ttf` | https://github.com/google/fonts/tree/main/ofl/amiri | SIL Open Font License 1.1, see `fonts/OFL-Amiri.txt` (Copyright 2010-2022 The Amiri Project Authors) |
| `fonts/UthmanicHafs_V18.ttf` | see Qur'an section | KFGQPC EULA |

## Geography

| File | Source | License |
|---|---|---|
| `geo/land_mask.json` (which 1° cells are land, for the Qibla globe) | Built by `tool/data/build_land_mask.py` from Natural Earth 1:110m land, https://www.naturalearthdata.com/ | Public domain |
