import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/hijri/fasting.dart';
import 'package:sabeeli/core/hijri/hijri_calendar.dart';
import 'package:sabeeli/core/hijri/hijri_date.dart';

void main() {
  const calendar = TabularHijriCalendar();
  Set<FastKind> on(int month, int day) =>
      Fasting.on(calendar, calendar.toGregorian(HijriDate(1448, month, day)));

  test('every day of Ramadan is Ramadan, and only that', () {
    for (var d = 1; d <= 29; d++) {
      expect(on(9, d), {FastKind.ramadan}, reason: 'Ramadan $d');
    }
  });

  test('no fast is suggested on the two Eids and the days of Tashriq', () {
    expect(on(10, 1), isEmpty);
    for (var d = 10; d <= 13; d++) {
      expect(on(12, d), isEmpty, reason: 'Dhu al-Hijjah $d');
    }
  });

  test('the days of the sunnah fasts', () {
    expect(on(12, 9), contains(FastKind.arafah));
    expect(on(1, 9), contains(FastKind.ashura));
    expect(on(1, 10), contains(FastKind.ashura));
    for (var d = 13; d <= 15; d++) {
      expect(on(7, d), contains(FastKind.whiteDays), reason: 'Rajab $d');
    }
    expect(on(7, 16), isNot(contains(FastKind.whiteDays)));
  });

  test('Mondays and Thursdays, and no other weekday', () {
    // A plain week in Rajab, away from the white days.
    for (var d = 20; d <= 26; d++) {
      final date = calendar.toGregorian(HijriDate(1448, 7, d));
      final expected =
          date.weekday == DateTime.monday || date.weekday == DateTime.thursday;
      expect(
        Fasting.on(calendar, date).contains(FastKind.mondayThursday),
        expected,
        reason: '$date',
      );
    }
  });
}
