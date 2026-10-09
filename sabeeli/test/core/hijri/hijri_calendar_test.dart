import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/hijri/hijri_calendar.dart';
import 'package:sabeeli/core/hijri/hijri_date.dart';

void main() {
  const tabular = TabularHijriCalendar();

  test('Julian day numbers round-trip', () {
    for (final d in [
      DateTime(622, 7, 19),
      DateTime(2000, 1, 1),
      DateTime(2026, 10, 9),
    ]) {
      expect(dateFromJulianDayNumber(julianDayNumber(d)), d);
    }
    expect(julianDayNumber(DateTime(2000, 1, 1)), 2451545);
  });

  test('tabular calendar: round-trips every day for 40 years', () {
    var day = DateTime(2000, 1, 1);
    for (var i = 0; i < 365 * 40; i++) {
      final h = tabular.fromGregorian(day);
      expect(tabular.toGregorian(h), day);
      day = DateTime(day.year, day.month, day.day + 1);
    }
  });

  test('tabular calendar: months are 29 or 30 days and years 354 or 355', () {
    for (var y = 1400; y < 1500; y++) {
      var total = 0;
      for (var m = 1; m <= 12; m++) {
        final len = tabular.daysInMonth(y, m);
        expect(len, anyOf(29, 30));
        total += len;
      }
      expect(total, anyOf(354, 355));
    }
  });

  test('tabular calendar is within a day or two of known dates', () {
    // 1 Ramadan 1447 was 18 Feb 2026 by Umm al-Qura.
    final ramadan = tabular.toGregorian(const HijriDate(1447, 9, 1));
    expect(
      ramadan.difference(DateTime(2026, 2, 18)).inDays.abs(),
      lessThanOrEqualTo(2),
    );
  });

  group('AdjustedHijriCalendar', () {
    test('day offset shifts every month start', () {
      const cal = AdjustedHijriCalendar(base: tabular, dayOffset: 1);
      const h = HijriDate(1447, 9, 1);
      expect(
        cal.toGregorian(h),
        DateTime(
          tabular.toGregorian(h).year,
          tabular.toGregorian(h).month,
          tabular.toGregorian(h).day + 1,
        ),
      );
    });

    test(
      'a month override pins that month and its neighbours stay 29–30 days',
      () {
        final ramadanIndex = const HijriDate(1447, 9, 1).monthIndex;
        for (final shift in [-2, -1, 1, 2]) {
          final computed = tabular.toGregorian(const HijriDate(1447, 9, 1));
          final announced = DateTime(
            computed.year,
            computed.month,
            computed.day + shift,
          );
          final cal = AdjustedHijriCalendar(
            base: tabular,
            monthOverrides: {ramadanIndex: announced},
          );
          expect(cal.fromGregorian(announced), const HijriDate(1447, 9, 1));
          final dayBefore = DateTime(
            announced.year,
            announced.month,
            announced.day - 1,
          );
          expect(cal.fromGregorian(dayBefore).month, 8);
          for (var m = 1; m <= 12; m++) {
            expect(
              cal.daysInMonth(1447, m),
              anyOf(29, 30),
              reason: 'month $m, shift $shift',
            );
          }
        }
      },
    );
  });

  test('Umm al-Qura table matches published dates', () {
    final json = jsonDecode(
      File('assets/hijri/ummalqura.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final cal = UmmAlQuraCalendar(
      firstMonthIndex: HijriDate(json['startYear'] as int, 1, 1).monthIndex,
      monthStarts: [for (final m in json['mjd'] as List) (m as int) + 2400001],
    );
    expect(cal.toGregorian(const HijriDate(1447, 9, 1)), DateTime(2026, 2, 18));
    expect(cal.toGregorian(const HijriDate(1446, 1, 1)), DateTime(2024, 7, 7));
    expect(
      cal.toGregorian(const HijriDate(1445, 10, 1)),
      DateTime(2024, 4, 10),
    );
    expect(
      cal.fromGregorian(DateTime(2026, 2, 18)),
      const HijriDate(1447, 9, 1),
    );
    for (var y = 1400; y < 1500; y++) {
      for (var m = 1; m <= 12; m++) {
        expect(cal.daysInMonth(y, m), anyOf(29, 30), reason: '$y-$m');
      }
    }
  });
}
