/// Font family names declared in pubspec.yaml (see assets/SOURCES.md).
abstract final class AppFonts {
  /// UI text, Arabic and Latin in one geometric family so mixed lines match.
  static const ui = 'ReadexPro';

  /// Glyphs Readex Pro lacks (Persian digits, Urdu letters) come from here.
  static const uiFallback = ['IBMPlexSansArabic'];

  /// Latin display: titles and large figures, a soft optical-size serif.
  static const serif = 'Fraunces';

  /// Arabic display: geometric Kufi for titles. Paired with [serif] through
  /// [displayFallback], so a title in any script picks the right face.
  static const kufi = 'ReemKufi';

  static const displayFallback = [kufi, ui, ...uiFallback];

  /// Naskh for adhkar and other long Arabic prose, and surah names.
  static const display = 'Amiri';

  /// King Fahd Complex Uthmanic Hafs. Only ever used for Quran text, which is
  /// encoded for this exact font.
  static const quran = 'UthmanicHafs';
}
