"""Uploads the release app bundle to Google Play from the command line.

Uses the Google Play Developer API (androidpublisher v3) directly: create an
edit, upload the bundle, put it on a track with release notes, commit.

Setup, once (see tool/release/README.md):
  pip install google-auth requests
  set SABEELI_PLAY_KEY to the service account's JSON key (never commit it)

Run from sabeeli/:
  flutter build appbundle --release
  python tool/release/upload_play.py                     # production, full rollout
  python tool/release/upload_play.py --track internal    # internal testing
  python tool/release/upload_play.py --rollout 0.2       # staged: 20 % of users
  python tool/release/upload_play.py --draft             # upload, release by hand
"""

import argparse
import json
import os
import pathlib
import re
import sys
import urllib.error
import urllib.request

PACKAGE = "dev.adez.sabeeli"
API = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/" + PACKAGE
UPLOAD = "https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications/" + PACKAGE
SCOPE = "https://www.googleapis.com/auth/androidpublisher"

APP = pathlib.Path(__file__).resolve().parents[2]
BUNDLE = APP / "build/app/outputs/bundle/release/app-release.aab"
NOTES = pathlib.Path(__file__).resolve().parent / "notes"


def token(key_path):
    try:
        from google.auth.transport.requests import Request
        from google.oauth2 import service_account
    except ImportError:
        sys.exit("Missing packages: pip install google-auth requests")
    creds = service_account.Credentials.from_service_account_file(key_path, scopes=[SCOPE])
    creds.refresh(Request())
    return creds.token


def call(method, url, bearer, body=None, data=None, content_type="application/json"):
    payload = data if data is not None else (json.dumps(body).encode() if body is not None else None)
    req = urllib.request.Request(url, data=payload, method=method)
    req.add_header("Authorization", "Bearer " + bearer)
    if payload is not None:
        req.add_header("Content-Type", content_type)
    try:
        with urllib.request.urlopen(req, timeout=600) as res:
            text = res.read().decode()
            return json.loads(text) if text else {}
    except urllib.error.HTTPError as e:
        sys.exit(f"{method} {url.split(PACKAGE)[-1]} failed ({e.code}):\n{e.read().decode()}")


def pubspec_version():
    text = (APP / "pubspec.yaml").read_text(encoding="utf-8")
    m = re.search(r"^version:\s*([\w.\-]+)\+(\d+)", text, re.M)
    return (m.group(1), int(m.group(2))) if m else (None, None)


def release_notes():
    """notes/<language>.txt, e.g. en-US.txt and ar.txt; at most 500 characters."""
    notes = []
    for f in sorted(NOTES.glob("*.txt")):
        text = f.read_text(encoding="utf-8").strip()
        if text:
            if len(text) > 500:
                sys.exit(f"{f.name}: release notes are limited to 500 characters")
            notes.append({"language": f.stem, "text": text})
    return notes


def main():
    ap = argparse.ArgumentParser(description="Upload app-release.aab to Google Play.")
    ap.add_argument("--track", default="production",
                    help="production, beta (open testing), alpha (closed) or internal")
    ap.add_argument("--rollout", type=float,
                    help="staged rollout fraction, e.g. 0.2 for 20 %% of users")
    ap.add_argument("--draft", action="store_true",
                    help="leave the release as a draft to review and send in Play Console")
    ap.add_argument("--key", default=os.environ.get("SABEELI_PLAY_KEY"),
                    help="service account JSON key (default: $SABEELI_PLAY_KEY)")
    ap.add_argument("--bundle", default=str(BUNDLE))
    args = ap.parse_args()

    if not args.key or not pathlib.Path(args.key).is_file():
        sys.exit("No service account key: set SABEELI_PLAY_KEY or pass --key")
    bundle = pathlib.Path(args.bundle)
    if not bundle.is_file():
        sys.exit(f"No bundle at {bundle}: run flutter build appbundle --release first")

    name, code = pubspec_version()
    notes = release_notes()
    status = "draft" if args.draft else ("inProgress" if args.rollout else "completed")
    print(f"Sabeeli {name} (code {code}) -> {args.track}, {status}"
          + (f" {args.rollout:.0%}" if args.rollout else ""))

    bearer = token(args.key)
    edit = call("POST", API + "/edits", bearer, body={})["id"]

    print(f"Uploading {bundle.stat().st_size / 1e6:.1f} MB ...")
    uploaded = call("POST", f"{UPLOAD}/edits/{edit}/bundles?uploadType=media", bearer,
                    data=bundle.read_bytes(), content_type="application/octet-stream")
    version_code = uploaded["versionCode"]
    if code is not None and version_code != code:
        print(f"Note: the bundle's version code is {version_code}, pubspec says {code}")

    release = {"name": name or str(version_code), "versionCodes": [str(version_code)], "status": status}
    if args.rollout:
        release["userFraction"] = args.rollout
    if notes:
        release["releaseNotes"] = notes
    call("PUT", f"{API}/edits/{edit}/tracks/{args.track}", bearer,
         body={"track": args.track, "releases": [release]})

    call("POST", f"{API}/edits/{edit}:commit", bearer)
    print(f"Done: version code {version_code} is on {args.track}"
          + (" as a draft; send it for review in Play Console." if args.draft else "."))


if __name__ == "__main__":
    main()
