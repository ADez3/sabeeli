# Releasing to Google Play from the command line

`upload_play.py` sends `build/app/outputs/bundle/release/app-release.aab` to
Google Play through the Google Play Developer API.

## One-time setup

1. **Google Cloud project.** At <https://console.cloud.google.com>, create a
   project (for example "sabeeli-release"), then open *APIs & Services → Library*
   and enable **Google Play Android Developer API**.
2. **Service account.** In *IAM & Admin → Service accounts*, create one (for
   example "play-upload"). It needs no Cloud roles. Open it, go to *Keys → Add key
   → Create new key → JSON*, and save the file **outside this repository**, next
   to the upload keystore.
3. **Give it access in Play Console.** In *Users and permissions → Invite new
   users*, invite the service account's email (`…@….iam.gserviceaccount.com`).
   Under *App permissions*, add Sabeeli with *Release apps to testing tracks*,
   *Release to production, exclude devices, and use Play App Signing*, and *View
   app information*. Send the invitation; it takes effect at once, though Google
   says it can take up to a day.
4. **Python packages:** `pip install google-auth requests`
5. **Point the script at the key**, once, in a terminal:

   ```sh
   setx SABEELI_PLAY_KEY "C:\path\to\the-key.json"
   ```

   Then open a new terminal.

## Each release

1. Raise `version` in `pubspec.yaml`: the number after `+` (the version code)
   must be higher than any bundle Play has seen. Keep `AppInfo.version` in step.
2. Write the release notes in `notes/en-US.txt` and `notes/ar.txt` (500
   characters at most each; the file name is the Play language code).
3. Build and upload, from `sabeeli/`:

   ```sh
   flutter build appbundle --release
   python tool/release/upload_play.py
   ```

Options: `--track internal|alpha|beta|production`, `--rollout 0.2` for a staged
rollout to 20 % of users, `--draft` to upload without releasing (finish it in
Play Console).

The key gives release access to the app: never commit it. The repository's
`.gitignore` refuses `*service-account*.json` and `play-*.json` as a safety net.
