import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/astronomy/calculation_method.dart';
import 'package:sabeeli/core/astronomy/coordinates.dart';
import 'package:sabeeli/core/astronomy/prayer.dart';
import 'package:sabeeli/core/astronomy/prayer_calculator.dart';
import 'package:sabeeli/core/astronomy/qibla.dart';

/// Asserts [actual] (a UTC instant) is within [toleranceMinutes] of the wall-clock
/// time [hhmm] on [date] in a zone [utcOffsetHours] from UTC.
void expectTime(
  DateTime actual,
  DateTime date,
  String hhmm,
  double utcOffsetHours, {
  int toleranceMinutes = 2,
}) {
  final parts = hhmm.split(':').map(int.parse).toList();
  final expected = DateTime.utc(
    date.year,
    date.month,
    date.day,
    parts[0],
    parts[1],
  ).subtract(Duration(minutes: (utcOffsetHours * 60).round()));
  final diff = actual.difference(expected).inMinutes.abs();
  expect(
    diff,
    lessThanOrEqualTo(toleranceMinutes),
    reason:
        'expected $hhmm, got ${actual.add(Duration(minutes: (utcOffsetHours * 60).round()))}',
  );
}

void main() {
  group('PrayerCalculator', () {
    test('Raleigh, ISNA + Hanafi matches the reference timetable (adhan-js fixture)', () {
      final date = DateTime(2015, 7, 12);
      final times = PrayerCalculator.calculate(
        coordinates: const Coordinates(latitude: 35.7750, longitude: -78.6336),
        date: date,
        parameters: const CalculationParameters(
          method: CalculationMethod.northAmerica,
          madhab: AsrMadhab.hanafi,
        ),
      );
      expectTime(times.fajr, date, '04:42', -4);
      expectTime(times.sunrise, date, '06:08', -4);
      expectTime(times.dhuhr, date, '13:21', -4);
      expectTime(times.asr, date, '18:22', -4);
      expectTime(times.maghrib, date, '20:32', -4);
      expectTime(times.isha, date, '21:57', -4);
    });

    test('Makkah, Umm al-Qura: Isha is exactly 90 minutes after Maghrib', () {
      final times = PrayerCalculator.calculate(
        coordinates: const Coordinates(latitude: 21.4225, longitude: 39.8262),
        date: DateTime(2024, 3, 15),
        parameters: const CalculationParameters(
          method: CalculationMethod.ummAlQura,
        ),
      );
      expect(times.isha.difference(times.maghrib), const Duration(minutes: 90));
      // Dhuhr in Makkah is close to 12:30 local (UTC+3) in mid-March.
      expectTime(
        times.dhuhr,
        DateTime(2024, 3, 15),
        '12:27',
        3,
        toleranceMinutes: 3,
      );
    });

    test('times are in order and the day boundaries are sane', () {
      final times = PrayerCalculator.calculate(
        coordinates: const Coordinates(
          latitude: 36.7538,
          longitude: 3.0588,
        ), // Algiers
        date: DateTime(2026, 10, 9),
        parameters: const CalculationParameters(
          method: CalculationMethod.algeria,
        ),
      );
      final ordered = Prayer.values.map(times.timeOf).toList();
      for (var i = 1; i < ordered.length; i++) {
        expect(
          ordered[i].isAfter(ordered[i - 1]),
          isTrue,
          reason: '${Prayer.values[i]}',
        );
      }
      expect(times.midnight.isAfter(times.isha), isTrue);
      expect(times.lastThird.isAfter(times.midnight), isTrue);
    });

    test(
      'high latitude in summer still yields a Fajr and an Isha (Oslo, June)',
      () {
        final times = PrayerCalculator.calculate(
          coordinates: const Coordinates(latitude: 59.9139, longitude: 10.7522),
          date: DateTime(2025, 6, 21),
          parameters: const CalculationParameters(),
        );
        expect(times.fajr.isBefore(times.sunrise), isTrue);
        expect(times.isha.isAfter(times.maghrib), isTrue);
      },
    );

    test('user adjustments shift only the targeted prayer', () {
      const coords = Coordinates(latitude: 33.5731, longitude: -7.5898);
      final date = DateTime(2026, 1, 1);
      final base = PrayerCalculator.calculate(
        coordinates: coords,
        date: date,
        parameters: const CalculationParameters(),
      );
      final shifted = PrayerCalculator.calculate(
        coordinates: coords,
        date: date,
        parameters: const CalculationParameters(
          userAdjustments: {Prayer.asr: 2},
        ),
      );
      expect(shifted.asr.difference(base.asr), const Duration(minutes: 2));
      expect(shifted.dhuhr, base.dhuhr);
    });
  });

  group('Qibla', () {
    test('known bearings', () {
      // Reference values from standard great-circle calculators.
      expect(
        Qibla.bearingFrom(
          const Coordinates(latitude: 51.5074, longitude: -0.1278),
        ),
        closeTo(118.99, 0.5),
      ); // London
      expect(
        Qibla.bearingFrom(
          const Coordinates(latitude: 40.7128, longitude: -74.0060),
        ),
        closeTo(58.48, 0.5),
      ); // New York
      expect(
        Qibla.bearingFrom(
          const Coordinates(latitude: -6.2088, longitude: 106.8456),
        ),
        closeTo(295.15, 0.5),
      ); // Jakarta
    });
  });

  group('Morocco (Ministry of Habous)', () {
    const casablanca = Coordinates(latitude: 33.5731, longitude: -7.5898);
    // The Ministry-calibrated Casablanca table for 17–23 October 2026, in GMT:
    // Fajr, sunrise, Dhuhr, Asr, Maghrib, Isha.
    const table = [
      '05:09 06:34 12:21 15:28 17:59 19:12',
      '05:10 06:34 12:21 15:27 17:58 19:11',
      '05:10 06:35 12:20 15:26 17:57 19:10',
      '05:11 06:36 12:20 15:25 17:56 19:09',
      '05:12 06:37 12:20 15:24 17:55 19:08',
      '05:13 06:38 12:20 15:23 17:54 19:07',
      '05:13 06:39 12:20 15:23 17:53 19:06',
    ];

    test('matches the published table to the minute, or one minute off', () {
      for (final (i, row) in table.indexed) {
        final date = DateTime(2026, 10, 17 + i);
        final times = PrayerCalculator.calculate(
          coordinates: casablanca,
          date: date,
          parameters: const CalculationParameters(
            method: CalculationMethod.morocco,
          ),
        );
        for (final (j, hhmm) in row.split(' ').indexed) {
          expectTime(
            times.timeOf(Prayer.values[j]),
            date,
            hhmm,
            0,
            toleranceMinutes: 1,
          );
        }
      }
    });

    test('the hour correction moves every time by whole hours', () {
      final date = DateTime(2026, 10, 17);
      PrayerTimes at(int shift) => PrayerCalculator.calculate(
        coordinates: casablanca,
        date: date,
        parameters: CalculationParameters(
          method: CalculationMethod.morocco,
          hourShift: shift,
        ),
      );
      final base = at(0);
      final back = at(-1);
      for (final p in Prayer.values) {
        expect(
          base.timeOf(p).difference(back.timeOf(p)),
          const Duration(hours: 1),
        );
      }
    });
  });
}
