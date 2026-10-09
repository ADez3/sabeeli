import 'package:flutter/widgets.dart';

import '../../../../core/hijri/hijri_date.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';

extension HijriLabels on AppLocalizations {
  String hijriMonthName(int month) => switch (month) {
    1 => hijriMonth1,
    2 => hijriMonth2,
    3 => hijriMonth3,
    4 => hijriMonth4,
    5 => hijriMonth5,
    6 => hijriMonth6,
    7 => hijriMonth7,
    8 => hijriMonth8,
    9 => hijriMonth9,
    10 => hijriMonth10,
    11 => hijriMonth11,
    _ => hijriMonth12,
  };
}

extension HijriFormat on BuildContext {
  /// "14 Rabi' al-Thani 1448 AH", with the language's digits.
  String formatHijri(HijriDate date) =>
      '${digits(date.day)} ${l10n.hijriMonthName(date.month)} '
      '${digits(date.year)} ${l10n.hijriYearSuffix}';
}
