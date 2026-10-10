import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/astronomy/coordinates.dart';
import 'package:sabeeli/core/astronomy/solar.dart';

void main() {
  const makkah = Coordinates(latitude: 21.4225, longitude: 39.8262);

  test('the sun is near the zenith over Makkah at noon in late May', () {
    // The sun passes directly over the Kaaba around 27–28 May at ~12:18 local
    // (09:18 UTC).
    final pos = Solar.sunAt(makkah, DateTime.utc(2025, 5, 27, 9, 18));
    expect(pos.altitude, greaterThan(88));
    expect(pos.hourAngle.abs(), lessThan(1.5));
  });

  test(
    'the sun is below the horizon at local midnight and rising in the morning',
    () {
      final midnight = Solar.sunAt(makkah, DateTime.utc(2025, 3, 1, 21, 0));
      expect(midnight.altitude, lessThan(-40));
      final morning = Solar.sunAt(makkah, DateTime.utc(2025, 3, 1, 5, 0));
      expect(morning.altitude, greaterThan(0));
      expect(morning.hourAngle, lessThan(0));
    },
  );

  test('moon age matches published new and full moons', () {
    // New moon 8 April 2024 18:21 UTC; full moon 23 April 2024 23:49 UTC.
    final newMoon = Solar.moonAge(DateTime.utc(2024, 4, 8, 18, 21));
    expect(newMoon < 0.6 || newMoon > 28.9, isTrue, reason: '$newMoon');
    expect(
      Solar.moonAge(DateTime.utc(2024, 4, 23, 23, 49)),
      closeTo(14.8, 0.8),
    );
  });
}
