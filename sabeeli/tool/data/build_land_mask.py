"""Builds assets/geo/land_mask.json: which 1-degree cells of the Earth are land.

Input: Natural Earth 1:110m land polygons (public domain), downloaded by
fetch_raw.sh to raw/geo/ne_110m_land.geojson.

Output: {"w": 360, "h": 180, "bits": "<base64>"}; bit (row * 360 + col) is set when
the centre of the cell at latitude 89.5 - row and longitude -179.5 + col is on land.
Bits are packed most-significant first within each byte.
"""
import base64
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, 'raw', 'geo', 'ne_110m_land.geojson')
OUT = os.path.join(HERE, '..', '..', 'assets', 'geo', 'land_mask.json')


def rings(geometry):
    if geometry['type'] == 'Polygon':
        yield geometry['coordinates']
    elif geometry['type'] == 'MultiPolygon':
        yield from geometry['coordinates']


def inside(lon, lat, ring):
    """Even-odd ray casting."""
    hit = False
    j = len(ring) - 1
    for i in range(len(ring)):
        xi, yi = ring[i][0], ring[i][1]
        xj, yj = ring[j][0], ring[j][1]
        if (yi > lat) != (yj > lat) and lon < (xj - xi) * (lat - yi) / (yj - yi) + xi:
            hit = not hit
        j = i
    return hit


def main():
    data = json.load(open(SRC, encoding='utf8'))
    polygons = []
    for feature in data['features']:
        for poly in rings(feature['geometry']):
            outer, holes = poly[0], poly[1:]
            xs = [p[0] for p in outer]
            ys = [p[1] for p in outer]
            polygons.append(((min(xs), max(xs), min(ys), max(ys)), outer, holes))

    w, h = 360, 180
    bits = bytearray((w * h + 7) // 8)
    land = 0
    for row in range(h):
        lat = 89.5 - row
        for col in range(w):
            lon = -179.5 + col
            on = False
            for (x0, x1, y0, y1), outer, holes in polygons:
                if x0 <= lon <= x1 and y0 <= lat <= y1 and inside(lon, lat, outer):
                    on = not any(inside(lon, lat, hole) for hole in holes)
                    if on:
                        break
            if on:
                land += 1
                i = row * w + col
                bits[i // 8] |= 0x80 >> (i % 8)

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    json.dump({'w': w, 'h': h, 'bits': base64.b64encode(bytes(bits)).decode()}, open(OUT, 'w'))
    print(f'{land} land cells of {w * h} ({land / (w * h):.1%}) -> {OUT}')


if __name__ == '__main__':
    main()
