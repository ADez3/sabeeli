import 'dart:math' as math;

import 'coordinates.dart';

/// Where a body is in the local sky.
class SkyPosition {
  const SkyPosition({required this.altitude, required this.hourAngle});

  /// Degrees above the horizon (negative below it).
  final double altitude;

  /// Degrees from the meridian, negative before it crosses (morning for the sun),
  /// in −180…180.
  final double hourAngle;
}

/// Low-precision positions of the sun and the moon, accurate to well under a degree
/// for the sun: enough to place them in a painted sky and to compute prayer times.
abstract final class Solar {
  /// Julian date of an instant.
  static double julian(DateTime instant) =>
      instant.toUtc().millisecondsSinceEpoch / 86400000.0 + 2440587.5;

  /// Declination of the sun and the equation of time (hours) at Julian date [jd].
  static ({double declination, double equation}) sun(double jd) {
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * _dsin(g) + 0.020 * _dsin(2 * g));
    final e = 23.439 - 0.00000036 * d;
    final ra = _darctan2(_dcos(e) * _dsin(l), _dcos(l)) / 15;
    return (
      declination: _darcsin(_dsin(e) * _dsin(l)),
      equation: q / 15 - _fixHour(ra),
    );
  }

  static SkyPosition sunAt(Coordinates where, DateTime instant) {
    final utc = instant.toUtc();
    final s = sun(julian(utc));
    final utcHours = utc.hour + utc.minute / 60 + utc.second / 3600;
    final solarTime = utcHours + where.longitude / 15 + s.equation;
    final hourAngle = _wrap180((solarTime - 12) * 15);
    return SkyPosition(
      altitude: _altitude(where.latitude, s.declination, hourAngle),
      hourAngle: hourAngle,
    );
  }

  /// Days since the last new moon, 0…29.53.
  static double moonAge(DateTime instant) {
    const synodic = 29.530588853;
    // A known new moon: 6 January 2000, 18:14 UTC.
    final age = (julian(instant) - 2451550.26) % synodic;
    return age < 0 ? age + synodic : age;
  }

  /// The moon trails the sun eastwards by its age (about 12.2° a day). Its
  /// declination is approximated by the sun's, which is fine for drawing it.
  static SkyPosition moonAt(Coordinates where, DateTime instant) {
    final sunPos = sunAt(where, instant);
    final elongation = moonAge(instant) / 29.530588853 * 360;
    final hourAngle = _wrap180(sunPos.hourAngle - elongation);
    final declination = sun(julian(instant)).declination;
    return SkyPosition(
      altitude: _altitude(where.latitude, declination, hourAngle),
      hourAngle: hourAngle,
    );
  }

  static double _altitude(
    double latitude,
    double declination,
    double hourAngle,
  ) => _darcsin(
    _dsin(latitude) * _dsin(declination) +
        _dcos(latitude) * _dcos(declination) * _dcos(hourAngle),
  );

  static double _wrap180(double a) {
    final r = (a + 180) % 360;
    return (r < 0 ? r + 360 : r) - 180;
  }

  static double _dsin(double d) => math.sin(d * math.pi / 180);
  static double _dcos(double d) => math.cos(d * math.pi / 180);
  static double _darcsin(double x) =>
      math.asin(x.clamp(-1.0, 1.0)) * 180 / math.pi;
  static double _darctan2(double y, double x) =>
      math.atan2(y, x) * 180 / math.pi;
  static double _fixAngle(double a) => a - 360 * (a / 360).floorToDouble();
  static double _fixHour(double a) => a - 24 * (a / 24).floorToDouble();
}
