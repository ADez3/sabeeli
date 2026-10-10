/// Font family names declared in pubspec.yaml (see assets/SOURCES.md).
abstract final class AppFonts {
  /// Everything but Quran text and adhkar: Arabic and Latin in one geometric
  /// family, so mixed lines match. Thin weights for large figures.
  static const ui = 'ReadexPro';

  /// Glyphs Readex Pro lacks (Persian digits, Urdu letters) come from here.
  static const uiFallback = ['IBMPlexSansArabic'];

  /// Naskh for adhkar and other long Arabic prose, and surah names.
  static const display = 'Amiri';

  /// King Fahd Complex Uthmanic Hafs. Quran text uses the font of the riwayah
  /// being read (`context.quranFont`); this is the Hafs one.
  static const quran = 'UthmanicHafs';
}
