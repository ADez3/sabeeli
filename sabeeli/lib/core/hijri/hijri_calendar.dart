import 'hijri_date.dart';

/// A rule that decides on which Gregorian day each Hijri month begins.
///
/// Implementations only need [monthStartJdn]; conversion both ways is derived from it,
/// so the tabular calendar, the Umm al-Qura table and the user's own corrections all
/// share one tested conversion routine.
abstract class HijriCalendar {
  const HijriCalendar();

  /// Julian Day Number of the 1st of the month at [monthIndex] (see
  /// [HijriDate.monthIndex]).
  int monthStartJdn(int monthIndex);

  int daysInMonth(int year, int month) {
    final index = HijriDate(year, month, 1).monthIndex;
    return monthStartJdn(index + 1) - monthStartJdn(index);
  }

  DateTime toGregorian(HijriDate date) =>
      dateFromJulianDayNumber(monthStartJdn(date.monthIndex) + date.day - 1);

  HijriDate fromGregorian(DateTime date) {
    final jdn = julianDayNumber(date);
    // Mean synodic month from the epoch gives a guess within a month or two; walk to
    // the exact month from there. Works for any calendar whose months are 29–30 days.
    var index = ((jdn - TabularHijriCalendar.epochJdn) / 29.530588853).floor();
    while (monthStartJdn(index) > jdn) {
      index--;
    }
    while (monthStartJdn(index + 1) <= jdn) {
      index++;
    }
    final ym = HijriDate.fromMonthIndex(index);
    return HijriDate(ym.year, ym.month, jdn - monthStartJdn(index) + 1);
  }
}

/// The arithmetical ("Kuwaiti") calendar: a fixed 30-year cycle with 11 leap years.
///
/// It never needs data and is never more than a day or two from observation, so it is
/// the fallback outside the Umm al-Qura table and an option of its own.
class TabularHijriCalendar extends HijriCalendar {
  const TabularHijriCalendar();

  /// 1 Muharram 1 AH = 16 July 622 (Julian calendar), civil epoch.
  static const epochJdn = 1948440;

  @override
  int monthStartJdn(int monthIndex) {
    final ym = HijriDate.fromMonthIndex(monthIndex);
    final y = ym.year;
    final m = ym.month;
    return (11 * y + 3) ~/ 30 +
        354 * y +
        30 * m -
        (m - 1) ~/ 2 +
        epochJdn -
        385;
  }
}

/// Saudi Arabia's official Umm al-Qura calendar, from the published table of month
/// starts. Months outside the table fall back to [TabularHijriCalendar].
class UmmAlQuraCalendar extends HijriCalendar {
  const UmmAlQuraCalendar({
    required this.firstMonthIndex,
    required this.monthStarts,
  });

  /// [HijriDate.monthIndex] of the first entry in [monthStarts].
  final int firstMonthIndex;

  /// Julian Day Numbers of consecutive month starts.
  final List<int> monthStarts;

  static const _fallback = TabularHijriCalendar();

  @override
  int monthStartJdn(int monthIndex) {
    final i = monthIndex - firstMonthIndex;
    if (i >= 0 && i < monthStarts.length) return monthStarts[i];
    return _fallback.monthStartJdn(monthIndex);
  }
}

/// A base calendar corrected by the user, because countries do not agree on when a
/// month begins: many follow a local moon sighting that differs from Umm al-Qura by a
/// day or two.
///
/// Two layers, applied in order:
///  * [dayOffset] moves every month start (follow a country that is usually a day
///    behind);
///  * [monthOverrides] pins the first day of specific months to an announced
///    Gregorian date ("Ramadan began on 1 March"), keyed by [HijriDate.monthIndex].
///    An override always wins. The months either side of it follow it, so that they
///    stay 29 or 30 days long: if Ramadan was announced a day late, Sha'ban also began
///    a day late; it did not last 31 days.
class AdjustedHijriCalendar extends HijriCalendar {
  const AdjustedHijriCalendar({
    required this.base,
    this.dayOffset = 0,
    this.monthOverrides = const {},
  });

  final HijriCalendar base;
  final int dayOffset;
  final Map<int, DateTime> monthOverrides;

  @override
  int monthStartJdn(int monthIndex) {
    final pinned = monthOverrides[monthIndex];
    if (pinned != null) return julianDayNumber(pinned);

    // Ripple from the nearest pinned month on each side: every month in between is
    // nudged just enough to stay 29–30 days long, which converges back onto the base
    // calendar within a month or two.
    var start = _unpinned(monthIndex);
    final later = _nearestPinned(monthIndex, 1);
    if (later != null) {
      var s = julianDayNumber(monthOverrides[later]!);
      for (var k = later - 1; k >= monthIndex; k--) {
        s = _unpinned(k).clamp(s - 30, s - 29);
      }
      start = s;
    }
    final earlier = _nearestPinned(monthIndex, -1);
    if (earlier != null) {
      var s = julianDayNumber(monthOverrides[earlier]!);
      for (var k = earlier + 1; k <= monthIndex; k++) {
        s = (k == monthIndex ? start : _unpinned(k)).clamp(s + 29, s + 30);
      }
      start = s;
    }
    return start;
  }

  int _unpinned(int monthIndex) => base.monthStartJdn(monthIndex) + dayOffset;

  /// Pinned months further than this have no effect: the ripple has died out by then.
  static const _rippleMonths = 6;

  int? _nearestPinned(int monthIndex, int direction) {
    for (var d = 1; d <= _rippleMonths; d++) {
      final k = monthIndex + d * direction;
      if (monthOverrides.containsKey(k)) return k;
    }
    return null;
  }
}
