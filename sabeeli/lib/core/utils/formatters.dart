import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';
import 'numerals.dart';

/// Locale-aware formatting shared by every screen. Every number shown to the user
/// goes through [digits], so the user's digit choice applies everywhere.
extension FormattersX on BuildContext {
  String get _locale => Localizations.localeOf(this).toLanguageTag();

  Numerals get numerals => NumeralsScope.of(this);

  /// Rewrites the digits of any text (an l10n string with a count, a page number…)
  /// in the user's digit style.
  String digits(Object text) => numerals.apply('$text');

  /// Wall-clock time of a UTC instant in the device's time zone, 12 or 24 h as the
  /// device prefers.
  String formatTime(DateTime instant) {
    final local = instant.toLocal();
    final use24 = MediaQuery.alwaysUse24HourFormatOf(this);
    return digits(
      (use24 ? DateFormat.Hm(_locale) : DateFormat.jm(_locale)).format(local),
    );
  }

  String formatWeekdayDate(DateTime date) =>
      digits(DateFormat.MMMMEEEEd(_locale).format(date));

  String formatShortDate(DateTime date) =>
      digits(DateFormat.yMMMd(_locale).format(date));

  String formatNumber(num value, {int decimals = 0}) => digits(
    NumberFormat.decimalPatternDigits(
      locale: _locale,
      decimalDigits: decimals,
    ).format(value),
  );

  /// "2 h 15 min" / "15 min", for "Asr in …".
  String formatDuration(Duration d) {
    final totalMinutes = d.inMinutes + (d.inSeconds % 60 > 0 ? 1 : 0);
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return digits(
      hours > 0
          ? l10n.durationHoursMinutes(hours, minutes)
          : l10n.durationMinutes(minutes),
    );
  }

  /// "01:42:09", a countdown that ticks every second.
  String formatCountdown(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return digits(
      '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}',
    );
  }
}
