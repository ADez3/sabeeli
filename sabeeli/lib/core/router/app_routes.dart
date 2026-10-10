/// Route paths and names. Navigate by name (`context.pushNamed(AppRoutes.qiblaName)`);
/// the paths double as deep links (`sabeeli://quran/2?ayah=255`).
///
/// Four places, one per tab: Today (the sky, the day and settings), the Quran,
/// Dhikr (adhkar, the misbaha, after-prayer) and the Qibla.
abstract final class AppRoutes {
  /// The first launch.
  static const welcome = '/welcome';
  static const welcomeName = 'welcome';

  static const today = '/today';
  static const todayName = 'today';

  /// `/today/day`: the day as a timeline of its prayers.
  static const prayer = 'day';
  static const prayerName = 'prayerTimes';

  /// `/today/calendar`: the moon-phase Hijri calendar and its adjustments.
  static const hijri = 'calendar';
  static const hijriName = 'hijriSettings';

  static const settings = 'settings';
  static const settingsName = 'settings';
  static const prayerSettings = 'prayer';
  static const prayerSettingsName = 'prayerSettings';
  static const location = 'location';
  static const locationName = 'location';
  static const reminders = 'reminders';
  static const remindersName = 'reminders';
  static const about = 'about';
  static const aboutName = 'about';

  static const quran = '/quran';
  static const quranName = 'quranIndex';

  /// `/quran/:surah?ayah=` opens the reader on the page holding that ayah.
  static const quranSurah = ':surah';
  static const quranSurahName = 'quranSurah';

  /// `/quran/intro/:surah`: the surah's opening, reached from its star.
  static const quranIntro = 'intro/:surah';
  static const quranIntroName = 'quranIntro';

  /// `/quran/page/:page`.
  static const quranPage = 'page/:page';
  static const quranPageName = 'quranPage';

  static const azkar = '/dhikr';
  static const azkarName = 'dhikr';
  static const azkarCategory = ':categoryId';
  static const azkarCategoryName = 'azkarReader';

  /// `/dhikr/after-prayer?prayer=fajr`; without `prayer`, the one most recently due.
  static const afterPrayer = 'after-prayer';
  static const afterPrayerName = 'afterPrayer';

  static const tasbih = 'tasbih';
  static const tasbihName = 'tasbih';

  static const qibla = '/qibla';
  static const qiblaName = 'qibla';
}
