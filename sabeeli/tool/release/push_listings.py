"""Publishes store listing texts to Google Play: one JSON file per language,
{"title", "shortDescription", "fullDescription"}, named by its Play language
code (en-US.json, ar.json, fr-FR.json ...). Graphics are left as they are.

Run from sabeeli/:
  python tool/release/push_listings.py                       # Sabeeli, ../docs/store/listings
  python tool/release/push_listings.py --dry-run             # check lengths only
  python tool/release/push_listings.py --package dev.adez.daky_ar --dir <folder>

Uses the same service account key as upload_play.py ($SABEELI_PLAY_KEY).
"""

import argparse
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import upload_play  # noqa: E402  (token(), call())

LIMITS = {"title": 30, "shortDescription": 80, "fullDescription": 4000}
APP = pathlib.Path(__file__).resolve().parents[2]


def load(folder):
    listings = {}
    for f in sorted(pathlib.Path(folder).glob("*.json")):
        d = json.loads(f.read_text(encoding="utf-8"))
        for key, limit in LIMITS.items():
            if not 0 < len(d.get(key, "")) <= limit:
                sys.exit(f"{f.name}: {key} is {len(d.get(key, ''))} characters (1-{limit})")
        listings[f.stem] = {k: d[k] for k in LIMITS}
    return listings


def main():
    ap = argparse.ArgumentParser(description="Publish store listing texts to Google Play.")
    ap.add_argument("--package", default=upload_play.PACKAGE)
    ap.add_argument("--dir", default=str(APP.parent / "docs/store/listings"))
    ap.add_argument("--key", default=upload_play.os.environ.get("SABEELI_PLAY_KEY"))
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    listings = load(args.dir)
    for lang, d in listings.items():
        print(f"{lang:6} title {len(d['title']):2}  short {len(d['shortDescription']):2}  "
              f"full {len(d['fullDescription']):4}")
    if args.dry_run:
        return
    if not args.key or not pathlib.Path(args.key).is_file():
        sys.exit("No service account key: set SABEELI_PLAY_KEY or pass --key")

    api = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/" + args.package
    bearer = upload_play.token(args.key)
    edit = upload_play.call("POST", api + "/edits", bearer, body={})["id"]
    for lang, d in listings.items():
        upload_play.call("PUT", f"{api}/edits/{edit}/listings/{lang}", bearer,
                         body={"language": lang, **d})
    upload_play.call("POST", f"{api}/edits/{edit}:commit", bearer)
    print(f"Published {len(listings)} listings for {args.package}.")


if __name__ == "__main__":
    main()
