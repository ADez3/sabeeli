/// Route paths and names. Navigate by name (`context.pushNamed(AppRoutes.qiblaName)`);
/// the paths double as deep links (`sabeeli://quran/2?ayah=255`).
abstract final class AppRoutes {
  static const home = '/home';
  static const homeName = 'home';

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

  static const prayer = '/prayer';
  static const prayerName = 'prayerTimes';
  static const prayerSettings = 'settings';
  static const prayerSettingsName = 'prayerSettings';
  static const location = 'location';
  static const locationName = 'location';

  static const azkar = '/azkar';
  static const azkarName = 'azkarCategories';
  static const azkarCategory = ':categoryId';
  static const azkarCategoryName = 'azkarReader';

  static const more = '/more';
  static const moreName = 'more';
  static const qibla = 'qibla';
  static const qiblaName = 'qibla';
  static const tasbih = 'tasbih';
  static const tasbihName = 'tasbih';
  static const settings = 'settings';
  static const settingsName = 'settings';
  static const hijri = 'hijri';
  static const hijriName = 'hijriSettings';
  static const about = 'about';
  static const aboutName = 'about';
}
