import 'package:equatable/equatable.dart';

class HijriDate extends Equatable implements Comparable<HijriDate> {
  const HijriDate(this.year, this.month, this.day)
    : assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 30, 'Hijri months have 29 or 30 days');

  final int year;

  /// 1 = Muharram … 9 = Ramadan … 12 = Dhu al-Hijjah.
  final int month;
  final int day;

  /// Months are counted from 1 Muharram 1 AH, which makes month arithmetic linear.
  int get monthIndex => (year - 1) * 12 + (month - 1);

  static ({int year, int month}) fromMonthIndex(int index) =>
      (year: index ~/ 12 + 1, month: index % 12 + 1);

  @override
  int compareTo(HijriDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  List<Object?> get props => [year, month, day];

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} AH';
}

/// Julian Day Number of a Gregorian civil date (the day starting at local midnight).
int julianDayNumber(DateTime date) {
  final a = (14 - date.month) ~/ 12;
  final y = date.year + 4800 - a;
  final m = date.month + 12 * a - 3;
  return date.day +
      (153 * m + 2) ~/ 5 +
      365 * y +
      y ~/ 4 -
      y ~/ 100 +
      y ~/ 400 -
      32045;
}

/// The Gregorian civil date (as a date-only local [DateTime]) of a Julian Day Number.
DateTime dateFromJulianDayNumber(int jdn) {
  final a = jdn + 32044;
  final b = (4 * a + 3) ~/ 146097;
  final c = a - 146097 * b ~/ 4;
  final d = (4 * c + 3) ~/ 1461;
  final e = c - 1461 * d ~/ 4;
  final m = (5 * e + 2) ~/ 153;
  final day = e - (153 * m + 2) ~/ 5 + 1;
  final month = m + 3 - 12 * (m ~/ 10);
  final year = 100 * b + d - 4800 + m ~/ 10;
  return DateTime(year, month, day);
}
