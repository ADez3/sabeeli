# Sabeeli: Privacy Policy

*Effective 10 October 2026*

Sabeeli is a free app for Muslims: prayer times, the Quran, adhkar, the Qibla
and the Hijri calendar. It has **no accounts, no advertising, no analytics and
no tracking**. Everything it knows about you stays on your phone, with the few
exceptions below, which all happen only when you use the feature concerned.

## What stays on your phone

- Your settings (language, digits, theme, riwayah, notification choices).
- Your location (coordinates and the name of the town).
- Your reading position, bookmarks, the pages and days you read, and your
  khatmah plan.
- Your tasbih counts.

None of this is sent anywhere. Uninstalling the app deletes it.

## Location

The app asks for your **approximate** location (never the precise one) to
calculate prayer times and the Qibla on your phone. You can also pick a city by
hand instead.

To show the name of your town, the app sends a position **rounded to about one
kilometre** to [OpenStreetMap Nominatim](https://nominatim.org/). When you
search for a city, the text you type is sent to Nominatim to find it. Nominatim
is run by the OpenStreetMap Foundation under its own
[privacy policy](https://osmfoundation.org/wiki/Privacy_Policy); like any web
server it sees your IP address.

## Translations

The tafsir al-Muyassar and one English translation are inside the app. Other
translations are downloaded only if you choose them, from the public
[quran-api](https://github.com/fawazahmed0/quran-api) files served by
[jsDelivr](https://www.jsdelivr.com/terms/privacy-policy-jsdelivr-net). The
request reveals your IP address to that service and nothing else.

## Notifications

Prayer notifications and reminders are scheduled on your phone. No server is
involved.

## Problem reports (beta)

If you shake your phone or tap "Report a problem", the app takes a screenshot of
the app's own screen and opens **your** email app with a message ready to send
to the developer. The message contains the screenshot (you can remove it), your
note, and technical details: the screen you were on, the app's language and
version, the riwayah, and your phone's operating system version. **Nothing is
sent unless you press send in your email app**, and then it is an ordinary email
from your address. Reports are used only to fix problems and are not shared.

## Permissions

| Permission | Why |
|---|---|
| Approximate location | Prayer times and the Qibla for where you are |
| Notifications | Prayer notifications and the reminders you turn on |
| Alarms & reminders (exact alarms) | So notifications come at the exact prayer time |
| Run at startup | To set the notifications again after the phone restarts |
| Vibration | Haptic feedback on the misbaha and the Qibla |
| Internet | Town names, city search, optional translation downloads |
| Motion sensors | The Qibla compass, the sky's parallax and shake-to-report, only while the app is open |

## Children

The app does not collect personal data from anyone, children included.

## Changes

If this policy changes, the new version will be published here with a new date.

## Contact

daky.adez.dev@gmail.com

The app's source code is public:
[github.com/ADez3/sabeeli](https://github.com/ADez3/sabeeli).
