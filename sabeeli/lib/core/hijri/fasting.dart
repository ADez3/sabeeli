import 'hijri_calendar.dart';

/// Why a day is a fasting day.
enum FastKind {
  /// Any day of Ramadan.
  ramadan,

  /// Mondays and Thursdays.
  mondayThursday,

  /// The 13th, 14th and 15th of the month (al-ayyam al-bid).
  whiteDays,

  /// 9 Dhu al-Hijjah.
  arafah,

  /// 9 and 10 Muharram (Tasu'a and 'Ashura).
  ashura,
}

/// Which fasts fall on a given day, by the user's Hijri calendar.
abstract final class Fasting {
  /// The voluntary fasts the user can be reminded of.
  static const voluntary = {
    FastKind.mondayThursday,
    FastKind.whiteDays,
    FastKind.arafah,
    FastKind.ashura,
  };

  /// The fasts on [date] (a local calendar day). Empty on the days fasting is
  /// not allowed: the two Eids and the days of Tashriq. In Ramadan, only
  /// [FastKind.ramadan]: the obligatory fast covers the day.
  static Set<FastKind> on(HijriCalendar calendar, DateTime date) {
    final h = calendar.fromGregorian(date);
    final eidAlFitr = h.month == 10 && h.day == 1;
    final eidAndTashriq = h.month == 12 && h.day >= 10 && h.day <= 13;
    if (eidAlFitr || eidAndTashriq) return const {};
    if (h.month == 9) return const {FastKind.ramadan};
    return {
      if (date.weekday == DateTime.monday || date.weekday == DateTime.thursday)
        FastKind.mondayThursday,
      if (h.day >= 13 && h.day <= 15) FastKind.whiteDays,
      if (h.month == 12 && h.day == 9) FastKind.arafah,
      if (h.month == 1 && (h.day == 9 || h.day == 10)) FastKind.ashura,
    };
  }
}
