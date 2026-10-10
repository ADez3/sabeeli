"""Draws the app icon and the launch artwork, and writes every size Android and
iOS need. The design: a path winding towards the sun rising on the horizon of
a night sky ("Sabeeli": my path). Drawn in code like the rest of the app.

Run from sabeeli/:  python tool/data/build_icon.py   (needs Pillow)
"""

import json
import math
import os

from PIL import Image, ImageDraw, ImageFilter

SS = 4  # supersampling

NIGHT = (10, 14, 26)
TWILIGHT_TOP = (16, 22, 52)
HORIZON_GLOW = (92, 70, 120)
AMBER = (244, 181, 106)
AMBER_HOT = (255, 226, 176)
MOON = (169, 194, 255)
LAND = (7, 10, 20)

HORIZON = 0.56  # height of the horizon, as a share of the layer
SUN_R = 0.10


def lerp(a, b, t):
    return tuple(round(x + (y - x) * t) for x, y in zip(a, b))


def sky(size):
    """The sky and the land: the adaptive icon's background layer."""
    s = size * SS
    img = Image.new('RGB', (s, s), NIGHT)
    px = img.load()
    hy = HORIZON * s
    for y in range(s):
        if y < hy:
            t = y / hy
            # Night at the top, warming towards the horizon.
            c = lerp(TWILIGHT_TOP, HORIZON_GLOW, t ** 2.2)
        else:
            c = LAND
        for x in range(s):
            px[x, y] = c
    # A wide amber glow where the sun rises.
    glow = Image.new('L', (s, s), 0)
    d = ImageDraw.Draw(glow)
    r = s * 0.42
    d.ellipse((s / 2 - r, hy - r * 0.55, s / 2 + r, hy + r * 0.55), fill=150)
    glow = glow.filter(ImageFilter.GaussianBlur(s * 0.09))
    amber = Image.new('RGB', (s, s), AMBER)
    img = Image.composite(amber, img, glow.point(lambda v: v * 0.55))
    # The land stays dark under the glow; a soft lip of light on the horizon.
    land = Image.new('L', (s, s), 0)
    ImageDraw.Draw(land).rectangle((0, hy, s, s), fill=255)
    img = Image.composite(Image.new('RGB', (s, s), LAND), img, land)
    lip = Image.new('L', (s, s), 0)
    ImageDraw.Draw(lip).rectangle((0, hy - s * 0.004, s, hy + s * 0.004), fill=120)
    lip = lip.filter(ImageFilter.GaussianBlur(s * 0.006))
    img = Image.composite(Image.new('RGB', (s, s), AMBER_HOT), img, lip)
    return img.resize((size, size), Image.LANCZOS)


def _path_polygon(s):
    """A road from the bottom edge to the foot of the sun: centred where it
    starts and where it ends, one gentle S between, narrowing with distance."""
    pts_l, pts_r = [], []
    steps = 160
    hy = HORIZON * s
    for i in range(steps + 1):
        t = i / steps  # 0 at the bottom, 1 at the horizon
        y = s - (s - hy) * t
        sway = math.sin(t * math.pi * 2) * s * 0.05 * (1 - t)
        cx = s / 2 + sway
        half = s * (0.25 * (1 - t) ** 1.7 + 0.003)
        pts_l.append((cx - half, y))
        pts_r.append((cx + half, y))
    return pts_l + pts_r[::-1]


def path_and_sun(size, mono=False):
    """The sun and the path: the adaptive icon's foreground (transparent)."""
    s = size * SS
    img = Image.new('RGBA', (s, s), (0, 0, 0, 0))
    hy = HORIZON * s
    r = SUN_R * s
    # The sun, half risen: a disc cut by the horizon, with a soft halo.
    if not mono:
        halo = Image.new('L', (s, s), 0)
        ImageDraw.Draw(halo).ellipse(
            (s / 2 - r * 2.2, hy - r * 2.2, s / 2 + r * 2.2, hy + r * 2.2),
            fill=140,
        )
        halo = halo.filter(ImageFilter.GaussianBlur(r * 0.9))
        cut = Image.new('L', (s, s), 0)
        ImageDraw.Draw(cut).rectangle((0, 0, s, hy), fill=255)
        halo = Image.composite(halo, Image.new('L', (s, s), 0), cut)
        img.paste(Image.new('RGBA', (s, s), AMBER + (255,)), (0, 0), halo)
    sun = Image.new('L', (s, s), 0)
    ImageDraw.Draw(sun).pieslice(
        (s / 2 - r, hy - r, s / 2 + r, hy + r), 180, 360, fill=255
    )
    sun_fill = Image.new('RGBA', (s, s), (255, 255, 255, 255) if mono else AMBER_HOT + (255,))
    img.paste(sun_fill, (0, 0), sun)
    # The path, brighter near the viewer, fading into the distance.
    mask = Image.new('L', (s, s), 0)
    ImageDraw.Draw(mask).polygon(_path_polygon(s), fill=255)
    fade = Image.new('L', (s, s), 0)
    fp = fade.load()
    for y in range(int(hy), s):
        t = (y - hy) / (s - hy)
        v = int(255 * (0.35 + 0.65 * t))
        for x in range(s):
            fp[x, y] = v
    from PIL import ImageChops
    mask = ImageChops.multiply(mask, fade) if not mono else mask
    colour = (255, 255, 255, 255) if mono else MOON + (255,)
    img.paste(Image.new('RGBA', (s, s), colour), (0, 0), mask)
    return img.resize((size, size), Image.LANCZOS)


# Launchers show the central 72dp of a 108dp adaptive icon: the art is laid
# out on the whole layer, and the opaque icons show that same window.
VISIBLE = 72 / 108


def full(size):
    """The whole icon, opaque (iOS, legacy Android and the store): the same
    window of the layers an adaptive launcher shows."""
    big = round(size / VISIBLE)
    base = sky(big).convert('RGBA')
    base.alpha_composite(path_and_sun(big))
    o = (big - size) // 2
    return base.crop((o, o, o + size, o + size)).convert('RGB')


def rounded(img, radius):
    mask = Image.new('L', img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, *img.size), radius, fill=255)
    out = Image.new('RGBA', img.size, (0, 0, 0, 0))
    out.paste(img, (0, 0), mask)
    return out


RES = 'android/app/src/main/res'
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}

for name, k in DENSITIES.items():
    d = f'{RES}/mipmap-{name}'
    os.makedirs(d, exist_ok=True)
    legacy = round(48 * k)
    rounded(full(legacy * 2).resize((legacy, legacy), Image.LANCZOS), legacy * 0.22).save(f'{d}/ic_launcher.png')
    layer = round(108 * k)
    # Adaptive layers are 108dp; the visible mask is the central 72dp.
    sky(layer).save(f'{d}/ic_launcher_background.png')
    path_and_sun(layer).save(f'{d}/ic_launcher_foreground.png')
    path_and_sun(layer, mono=True).save(f'{d}/ic_launcher_monochrome.png')
    # Launch artwork for Android < 12: the icon as a 120dp rounded tile.
    tile = round(120 * k)
    os.makedirs(f'{RES}/drawable-{name}', exist_ok=True)
    rounded(full(tile), tile * 0.24).save(f'{RES}/drawable-{name}/splash_icon.png')

os.makedirs(f'{RES}/mipmap-anydpi-v26', exist_ok=True)
with open(f'{RES}/mipmap-anydpi-v26/ic_launcher.xml', 'w', encoding='utf8') as f:
    f.write('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />
</adaptive-icon>
''')

IOS = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
contents = json.load(open(f'{IOS}/Contents.json', encoding='utf8'))
big = full(1024)
for image in contents['images']:
    pts = float(image['size'].split('x')[0])
    scale = int(image['scale'][0])
    px = round(pts * scale)
    big.resize((px, px), Image.LANCZOS).save(f"{IOS}/{image['filename']}")

LAUNCH = 'ios/Runner/Assets.xcassets/LaunchImage.imageset'
for scale, name in ((1, 'LaunchImage.png'), (2, 'LaunchImage@2x.png'), (3, 'LaunchImage@3x.png')):
    tile = 120 * scale
    rounded(full(tile), tile * 0.24).save(f'{LAUNCH}/{name}')

# For the README and the stores.
full(512).save('../docs/icon.png')
print('done')
