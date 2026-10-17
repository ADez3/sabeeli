# Google Play listing

Copy-paste texts for the store listing, in English (default) and Arabic.
Limits: app name 30 characters, short description 80, full description 4000.

Graphics in this folder:

- `icon-512.png`: app icon, 512 × 512.
- `feature-graphic.png`: feature graphic, 1024 × 500.
- `phone/`: English phone screenshots, 2160 × 3840 (9:16), the app in a phone frame
  with a headline.
- `phone_ar/`: the same in Arabic, with the app in Arabic (Arabic-Indic digits).
  Upload these under the Arabic translation of the listing.

The screenshots are JPEG (quality 92) to keep the repository light; Play
accepts JPEG or PNG.

The listing texts are in `listings/<play-language-code>.json` (title, short and
full description), one file per language. Publish them with
`python tool/release/push_listings.py` from `sabeeli/`.
