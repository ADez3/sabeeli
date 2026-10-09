/// Font family names declared in pubspec.yaml.
abstract final class AppFonts {
  /// UI text in every script it covers (Arabic and Latin). Other scripts (Urdu
  /// Nastaliq, Bengali, CJK…) fall back to the platform's fonts.
  static const ui = 'IBMPlexSansArabic';

  /// Decorative Arabic: surah titles, headings, the basmala ornament.
  static const display = 'Amiri';

  /// King Fahd Complex Uthmanic Hafs. Only ever used for Quran text, which is
  /// encoded for this exact font.
  static const quran = 'UthmanicHafs';
}
