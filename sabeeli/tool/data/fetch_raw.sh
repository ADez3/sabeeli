#!/usr/bin/env bash
# Download every raw input used by the build scripts into tool/data/raw/.
# Then run (from tool/data):
#   python build_quran.py && python fetch_tafsir_translation.py && python build_translation_catalog.py
#   python build_azkar.py && python build_hijri.py
# Fonts are copied directly (see the bottom of this script).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
R="$HERE/raw"; A="$HERE/../../assets"
mkdir -p "$R/hisn/ar" "$R/hisn/en" "$R/seen" "$R/other" "$R/hijri" "$A/fonts"

# Quran text + font (KFGQPC Hafs v18, mirror of qurancomplex.gov.sa developer package)
K=https://raw.githubusercontent.com/thetruetruth/quran-data-kfgqpc/main/hafs
curl -sSL -o "$R/hafsData_v18.json" "$K/data/hafsData_v18.json"
curl -sSL -o "$R/hafs.18.ttf" "$K/font/hafs.18.ttf"
cp "$R/hafs.18.ttf" "$A/fonts/UthmanicHafs_V18.ttf"
# Metadata
curl -sSL -o "$R/quran-data.js" https://tanzil.net/res/text/metadata/quran-data.js
curl -sSL -o "$R/qurancom_chapters.json" "https://api.quran.com/api/v4/chapters?language=en"
# Saheeh International (Muyassar is fetched per chapter by fetch_tafsir_translation.py)
curl -sSL -o "$R/qc_trans20.json" https://api.quran.com/api/v4/quran/translations/20
# Hisn al-Muslim
curl -sSL -o "$R/hisn/husn_ar.json" http://www.hisnmuslim.com/api/ar/husn_ar.json
curl -sSL -o "$R/hisn/husn_en.json" http://www.hisnmuslim.com/api/en/husn_en.json
for i in $(seq 1 132); do for l in ar en; do
  curl -sSL -o "$R/hisn/$l/$i.json" "http://www.hisnmuslim.com/api/$l/$i.json"; done; done
curl -sSL -o "$R/other/asellam_hisn.json" https://raw.githubusercontent.com/asellam/HisnElMuslim/main/hisn.json
S=https://raw.githubusercontent.com/Seen-Arabic/Morning-And-Evening-Adhkar-DB/main
curl -sSL -o "$R/seen/ar.json" "$S/ar.json"; curl -sSL -o "$R/seen/en.json" "$S/en.json"
curl -sSL -o "$R/seen/LICENSE" "$S/LICENSE"
# Umm al-Qura
H=https://raw.githubusercontent.com/dralshehri/hijridate/main
curl -sSL -o "$R/hijri/ummalqura.py" "$H/src/hijridate/ummalqura.py"
curl -sSL -o "$R/hijri/LICENSE" "$H/LICENSE"
# UI fonts (google/fonts, OFL)
G=https://raw.githubusercontent.com/google/fonts/main/ofl
for w in Regular Medium SemiBold Bold; do
  curl -sSL -o "$A/fonts/IBMPlexSansArabic-$w.ttf" "$G/ibmplexsansarabic/IBMPlexSansArabic-$w.ttf"; done
curl -sSL -o "$A/fonts/OFL-IBMPlexSansArabic.txt" "$G/ibmplexsansarabic/OFL.txt"
for w in Regular Bold; do curl -sSL -o "$A/fonts/Amiri-$w.ttf" "$G/amiri/Amiri-$w.ttf"; done
curl -sSL -o "$A/fonts/OFL-Amiri.txt" "$G/amiri/OFL.txt"
