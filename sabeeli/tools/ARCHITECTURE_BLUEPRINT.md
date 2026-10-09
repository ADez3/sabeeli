# Sabeeli — Architecture Blueprint

Sabeeli (سبيلي, "my path") is a free, offline-first companion app for Muslims: prayer
times with prayer notifications, Qibla, the Quran with tafsir, azkar, tasbih and a
user-adjustable Hijri calendar. No backend; everything is computed or bundled on the
device, and the few optional downloads (extra translations, recitation audio) come
from free public CDNs.

## 1. Principles

1. **Offline first.** Prayer times, Qibla and Hijri dates are computed on the device.
   Quran text, the default tafsir/translation and the azkar ship as assets. The network
   is optional, never required.
2. **Own the logic, rent the platform.** Pure Dart logic (astronomy, Hijri calendar,
   Quran indexing, search, `Result`) is written in-house and unit-tested. A package is
   only taken when it wraps OS integration that is expensive to get right on every
   platform, and only from a well-maintained publisher.
3. **No background jobs.** Prayer times are deterministic, so the next days of prayer
   notifications are scheduled as exact OS alarms, and the schedule is rebuilt whenever
   its inputs change (see §6).
4. **Quran text is never altered.** It is loaded verbatim from the King Fahd Complex
   (KFGQPC) Hafs text and rendered only with the font that text was encoded for.
5. **Every language.** The UI goes through gen-l10n. The Quran stays Arabic, and its
   translations are chosen per language from a catalogue and downloaded on demand.
6. **Responsive everywhere.** Android is tested first, but layouts are built with
   breakpoints (compact / medium / expanded) so tablets, desktop and web work later.

## 2. Packages

| Package | Why it isn't written in-house |
|---|---|
| `flutter_bloc`, `equatable` | State management. The house standard. |
| `get_it`, `injectable` (+ `injectable_generator`, `build_runner`) | DI. The house standard. |
| `go_router` | Flutter-team routing, with deep links. |
| `flutter_localizations`, `intl` | Flutter SDK l10n. |
| `shared_preferences` | Flutter-team key/value storage for settings, bookmarks and last read. |
| `path_provider` | Flutter-team; where downloaded translations are cached. |
| `flutter_local_notifications` (+ `timezone`) | Exact alarms, channels, custom sounds and reschedule-on-boot across Android and iOS. |
| `geolocator` | Location permissions and fixes across OS versions. |

**Written in-house instead of taking a package:**
- `Result<T>` instead of fpdart/dartz.
- Prayer-time calculation instead of `adhan`.
- Qibla bearing.
- The Hijri calendar.
- The compass, through our own method/event channel.
- Reverse geocoding, through our own HTTP call to OpenStreetMap Nominatim.
- Translation downloads, through `dart:io`'s `HttpClient`.

**Phase 2 candidates:** `just_audio` (recitation), and a home-widget bridge written as
our own native code.

## 3. Folder structure

```
lib/
  main.dart                  bootstrap: bindings → DI → runApp
  app.dart                   MaterialApp.router inside SettingsCubit (theme, locale)
  l10n/                      gen-l10n ARB files (intl_en.arb is the template) + generated code
  core/
    di/                      injection.dart (@InjectableInit) + RegisterModule
    error/                   exceptions.dart, failures.dart (sealed), error_handler.dart
    result/                  result.dart: sealed Result<T> = Ok | Err, fold/map
    usecases/                UseCase<T, Params>, StreamUseCase, NoParams
    router/                  app_routes.dart (paths + names), app_router.dart
    theme/                   palette, semantic colours (ThemeExtension), typography, spacing, AppTheme
    layout/                  breakpoints + responsive helpers
    astronomy/               solar position, prayer-time calculator, qibla bearing (pure Dart)
    hijri/                   Umm al-Qura table + tabular calendar + user adjustments (pure Dart)
    storage/                 typed wrapper around SharedPreferences
    widgets/                 shared widgets (cards, decorative backgrounds, section headers)
    utils/                   number/locale formatting, extensions
  features/
    shell/                   bottom navigation / navigation rail (StatefulShellRoute)
    home/                    dashboard: next prayer, Hijri date, last read, daily ayah, shortcuts
    prayer_times/            settings, today's times, location, prayer notification scheduling
    qibla/                   compass channel + qibla screen
    quran/                   index (surah / juz), reader, bookmarks, last read, tafsir & translations
    azkar/                   categories, guided counter reader
    tasbih/                  counter with presets and history
    settings/                theme, language, calculation method, Hijri adjustments, notifications
```

Every feature uses the same three layers:

```
data/        datasources/ (assets, prefs, platform channels), models/ (fromJson/toJson by hand),
             repositories/ (*RepositoryImpl, catch → Err(ErrorHandler.toFailure(e)))
domain/      entities/, repositories/ (abstract), usecases/ (*UseCase implements UseCase<T, P>)
presentation/bloc|cubit/, pages/, widgets/
```

## 4. Conventions

- **Errors:** data sources throw a `sealed AppException`. Repositories catch it and return
  `Err(failure)` through `ErrorHandler.toFailure`, which is the only place errors are
  mapped. Nothing above the repository catches.
- **Use cases:** `@injectable class XxxUseCase implements UseCase<T, XxxParams>`. Params are
  `Equatable`.
- **Blocs:** events are `sealed ... extends Equatable`, named `...Requested` or `...Changed`.
  - Screens that keep their data across phases use a single state class with a status enum
    and `copyWith`.
  - Simple flows use sealed state hierarchies.
  - States hold `Failure` objects, never strings. Widgets turn failures and notice codes
    into localized text.
- **DI:** classes are annotated (`@injectable`, `@lazySingleton`, `@LazySingleton(as:)`).
  `build.yaml` limits the generator to `lib/core/di/injection.dart`.
  Regenerate with `dart run build_runner build --delete-conflicting-outputs`.
- **Routing:**
  - Every route has a `name:`.
  - Navigate with `context.goNamed` / `pushNamed`.
  - Path parameters are ids (surah number, ayah number, category id), never objects.
  - Deep links use `sabeeli://` and paths that mirror the routes, for example
    `/quran/2?ayah=255`.
- **Doc comments** explain *why*, not *what*.

## 5. Navigation

A `StatefulShellRoute.indexedStack` has five branches: **Home · Quran · Prayer · Azkar ·
More**. On compact screens the shell is a `NavigationBar`, and on medium and expanded
screens it is a `NavigationRail`.

| Route | Name |
|---|---|
| `/home` | home |
| `/quran` | quranIndex |
| `/quran/:surah?ayah=` | quranReader |
| `/quran/bookmarks` | quranBookmarks |
| `/prayer` | prayerTimes |
| `/prayer/settings` | prayerSettings |
| `/azkar` | azkarCategories |
| `/azkar/:categoryId` | azkarReader |
| `/more` | more |
| `/more/qibla` | qibla |
| `/more/tasbih` | tasbih |
| `/more/settings` | settings |
| `/more/settings/hijri` | hijriSettings |

## 6. Prayer times and notifications

- **Calculator** (`core/astronomy`): the standard solar-position algorithms (Jean Meeus,
  "Astronomical Algorithms", as used by PrayTimes.org).
  - Methods: MWL, ISNA, Egypt, Umm al-Qura, Karachi, Tehran, Gulf, Kuwait, Qatar,
    Singapore, Turkey (Diyanet), France (UOIF 12°), Russia, Dubai, Morocco, Algeria,
    Tunisia, Jordan, and a custom method.
  - Asr: Shafi'i, Maliki or Hanbali (shadow factor 1), or Hanafi (factor 2).
  - High-latitude rules: middle of the night, one-seventh, or twilight angle.
  - Per-prayer minute adjustments.
  - Results are tested against published timetables.
- **Default method by country:** reverse geocoding returns the country code, which picks
  the method. The user can override it.
- **Scheduling:** compute the next 7 days of prayer times (iOS allows only 64 pending
  notifications, and 5 × 7 = 35 leaves room for reminders) and schedule them through
  `flutter_local_notifications` with `AndroidScheduleMode.exactAllowWhileIdle`, at absolute
  UTC instants. The schedule is rebuilt on:
  - app start or resume,
  - a settings change,
  - the location moving by more than 5 km,
  - the time zone changing.

  The plugin's boot receiver re-arms alarms after a reboot.
- **Sounds:** notifications use the phone's own notification sound (or none, per
  prayer). The app ships no audio.

## 7. Hijri calendar

The Hijri date is user-adjustable because countries do not agree on month starts.

- **Methods:**
  - Umm al-Qura, a bundled table covering 1356–1500 AH.
  - Tabular (arithmetical / Kuwaiti), a fallback outside the table.
- **Global day offset:** −2 to +2 days.
- **Per-month override:** "this month began on <Gregorian date>". It is stored as
  `yyyy-mm → ISO date` and wins over the method and the offset. This lets a user follow
  their local moon-sighting announcement for Ramadan, the Eids and so on.
- **Display:** Hijri month names come from l10n. Important dates (Ramadan, the Eids, Arafah,
  Ashura, the white days) are derived from the user's adjusted calendar.

## 8. Quran

- **Text:** KFGQPC Uthmanic Hafs text, verbatim, rendered with the KFGQPC `UthmanicHafs`
  font in the encoding the font was built for.
  - The basmala is rendered as a separate header for every surah except At-Tawbah.
    Al-Fatihah's first ayah is the basmala itself.
  - The end-of-ayah ornament shows the number in Arabic-Indic digits.
- **Metadata:** surah names (Arabic and transliterated), revelation place, ayah count, juz,
  hizb quarters, the 604-page Madani mushaf page starts, and sajda positions.
- **Reader:** scrolls continuously by surah, and can also jump by juz or page.
  - Font size can be adjusted.
  - Tapping an ayah opens a sheet with its tafsir and translation, plus copy, share,
    bookmark and "set as last read".
  - The reading position is saved automatically.
- **Tafsir and translation:** Arabic Tafsir al-Muyassar and English Saheeh International
  are bundled. Other languages come from a catalogue (fawazahmed0/quran-api on jsDelivr),
  are downloaded on demand and cached in the app's documents directory.
- **Phase 2:** recitation audio, word-by-word, full-text search, khatmah planner.

## 9. Delivery phases

**Phase 1 (v0.1):**
- core
- shell and theme (dark-first, light mode, calm and modern)
- l10n: en, ar, fr, ur, id, tr. Adding more is just adding ARB files.
- prayer times with notifications
- qibla
- Quran reader with tafsir, bookmarks and last read
- azkar
- tasbih
- Hijri calendar with adjustments
- settings

**Phase 2:**
- recitation audio
- Quran search
- more UI languages (ms, bn, fa, de, es, ru, ha, sw, so, ps…)
- home-screen widgets
- Ramadan mode
- qada tracker
- Asma ul-Husna
- daily-ayah notification

## 10. Data sources and licences

See `assets/SOURCES.md` for every bundled file and its attribution. In short:
- KFGQPC (King Fahd Complex): text, font and Tafsir al-Muyassar.
- Tanzil: metadata, under CC BY 3.0 with the text kept unaltered.
- Hisn al-Muslim: the azkar.
- Google Fonts: OFL UI fonts.
