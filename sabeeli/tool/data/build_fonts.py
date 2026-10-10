"""Downloads the UI fonts from github.com/google/fonts (all SIL OFL 1.1) and cuts
static instances out of the variable files, one per weight the app uses.

Static files are bundled instead of the variable ones so `FontWeight` selects the
right face on every platform without per-style `FontVariation`s.

Run from sabeeli/:  python tool/data/build_fonts.py   (needs `pip install fonttools`)
"""

import os
import urllib.request

from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

RAW = 'tool/data/raw/fonts'
OUT = 'assets/fonts'
GF = 'https://raw.githubusercontent.com/google/fonts/main/ofl'

FONTS = {
    # Arabic and Latin UI text: one family, so mixed-script lines match.
    'ReadexPro': {
        'url': f'{GF}/readexpro/ReadexPro%5BHEXP,wght%5D.ttf',
        'license': f'{GF}/readexpro/OFL.txt',
        'instances': {w: {'wght': w, 'HEXP': 0} for w in (300, 400, 500, 600)},
    },
    # Latin display: titles and the big numbers' companions.
    'Fraunces': {
        'url': f'{GF}/fraunces/Fraunces%5BSOFT,WONK,opsz,wght%5D.ttf',
        'license': f'{GF}/fraunces/OFL.txt',
        'instances': {
            w: {'wght': w, 'opsz': 72, 'SOFT': 100, 'WONK': 0} for w in (300, 500)
        },
    },
    # Arabic display: geometric Kufi for titles.
    'ReemKufi': {
        'url': f'{GF}/reemkufi/ReemKufi%5Bwght%5D.ttf',
        'license': f'{GF}/reemkufi/OFL.txt',
        'instances': {w: {'wght': w} for w in (500, 700)},
    },
}


def fetch(url, path):
    if not os.path.exists(path):
        print('download', url)
        urllib.request.urlretrieve(url, path)


os.makedirs(RAW, exist_ok=True)
for family, spec in FONTS.items():
    src = os.path.join(RAW, f'{family}-VF.ttf')
    fetch(spec['url'], src)
    fetch(spec['license'], os.path.join(OUT, f'OFL-{family}.txt'))
    for weight, axes in spec['instances'].items():
        font = TTFont(src)
        axes = {k: v for k, v in axes.items()
                if k in {a.axisTag for a in font['fvar'].axes}}
        static = instantiateVariableFont(font, axes, updateFontNames=False)
        out = os.path.join(OUT, f'{family}-{weight}.ttf')
        static.save(out)
        print(out, os.path.getsize(out) // 1024, 'KB')
