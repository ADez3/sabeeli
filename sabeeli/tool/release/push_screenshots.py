"""Replaces the phone screenshots of Google Play listings with the images in a
folder (sorted by name, so 01_..., 02_... keep their order).

  python tool/release/push_screenshots.py --dir ../docs/store/phone --lang en-US
  python tool/release/push_screenshots.py --package dev.adez.daky_ar \\
      --dir ../../daky_ar/docs/store/phone --lang ar --lang en-US

Uses the same service account key as upload_play.py ($SABEELI_PLAY_KEY).
"""

import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import upload_play  # noqa: E402

TYPES = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg"}


def main():
    ap = argparse.ArgumentParser(description="Replace phone screenshots on Google Play.")
    ap.add_argument("--package", default=upload_play.PACKAGE)
    ap.add_argument("--dir", required=True)
    ap.add_argument("--lang", action="append", required=True, help="listing language, repeatable")
    ap.add_argument("--key", default=upload_play.os.environ.get("SABEELI_PLAY_KEY"))
    args = ap.parse_args()

    images = sorted(p for p in pathlib.Path(args.dir).iterdir() if p.suffix.lower() in TYPES)
    if not 2 <= len(images) <= 8:
        sys.exit(f"Play needs 2 to 8 phone screenshots; found {len(images)} in {args.dir}")
    if not args.key or not pathlib.Path(args.key).is_file():
        sys.exit("No service account key: set SABEELI_PLAY_KEY or pass --key")

    pkg = args.package
    api = f"https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{pkg}"
    upload = f"https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications/{pkg}"
    bearer = upload_play.token(args.key)
    edit = upload_play.call("POST", api + "/edits", bearer, body={})["id"]
    for lang in args.lang:
        upload_play.call("DELETE", f"{api}/edits/{edit}/listings/{lang}/phoneScreenshots", bearer)
        for img in images:
            upload_play.call("POST", f"{upload}/edits/{edit}/listings/{lang}/phoneScreenshots?uploadType=media",
                             bearer, data=img.read_bytes(), content_type=TYPES[img.suffix.lower()])
        print(f"{lang}: {len(images)} screenshots")
    upload_play.call("POST", f"{api}/edits/{edit}:commit", bearer)
    print(f"Published for {pkg}.")


if __name__ == "__main__":
    main()
