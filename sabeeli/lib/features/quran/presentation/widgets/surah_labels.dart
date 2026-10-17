import 'package:flutter/widgets.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';

extension SurahLabels on BuildContext {
  /// The surah's name as a reader of the current UI language knows it: in
  /// Arabic script for readers of Arabic, Persian and Urdu, the common
  /// transliteration for everyone else.
  String surahName(SurahInfo surah) =>
      readsArabicScript ? surah.nameArabic : surah.nameTransliterated;

  /// Arabic, Persian and Urdu readers know the surah names in Arabic script, so
  /// a calligraphic name beside the title would only repeat it.
  bool get readsArabicScript => const {'ar', 'fa', 'ur'}.contains(languageCode);

  /// "Meccan · 286 ayahs" (with the English meaning for English readers).
  String surahSubtitle(SurahInfo surah) {
    final l10n = this.l10n;
    final parts = [
      if (languageCode == 'en') ?surah.meaningIfDistinct,
      surah.revelation == Revelation.meccan ? l10n.meccan : l10n.medinan,
      digits(l10n.ayahCount(surah.ayahCount)),
    ];
    return parts.join(' · ');
  }
}
