import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'calculation_method.dart';
import 'coordinates.dart';
import 'prayer.dart';

/// Everything that changes the computed times, so a cached [PrayerTimes] can be
/// compared against the current settings with `==`.
class CalculationParameters extends Equatable {
  const CalculationParameters({
    this.method = CalculationMethod.muslimWorldLeague,
    this.madhab = AsrMadhab.standard,
    this.highLatitudeRule = HighLatitudeRule.middleOfTheNight,
    this.userAdjustments = const {},
  });

  final CalculationMethod method;
  final AsrMadhab madhab;
  final HighLatitudeRule highLatitudeRule;

  /// Minutes the user added or removed per prayer, on top of the method's own
  /// [CalculationMethod.adjustments] (to match the local mosque, for example).
  final Map<Prayer, int> userAdjustments;

  int adjustmentFor(Prayer prayer) =>
      (method.adjustments[prayer] ?? 0) + (userAdjustments[prayer] ?? 0);

  CalculationParameters copyWith({
    CalculationMethod? method,
    AsrMadhab? madhab,
    HighLatitudeRule? highLatitudeRule,
    Map<Prayer, int>? userAdjustments,
  }) => CalculationParameters(
    method: method ?? this.method,
    madhab: madhab ?? this.madhab,
    highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
    userAdjustments: userAdjustments ?? this.userAdjustments,
  );

  @override
  List<Object?> get props => [
    method,
    madhab,
    highLatitudeRule,
    userAdjustments,
  ];
}

/// The prayer times of one local day. All values are UTC instants; call
/// `toLocal()` (or format in a time zone) to display them.
class PrayerTimes extends Equatable {
  const PrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.midnight,
    required this.lastThird,
  });

  /// The local calendar day these times belong to (time part is midnight).
  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  /// Islamic midnight: the end of the preferred Isha time.
  final DateTime midnight;

  /// Start of the last third of the night, the recommended time for qiyam.
  final DateTime lastThird;

  DateTime timeOf(Prayer prayer) => switch (prayer) {
    Prayer.fajr => fajr,
    Prayer.sunrise => sunrise,
    Prayer.dhuhr => dhuhr,
    Prayer.asr => asr,
    Prayer.maghrib => maghrib,
    Prayer.isha => isha,
  };

  /// The prayer whose time has most recently begun at [now], or null before Fajr.
  Prayer? currentAt(DateTime now) {
    Prayer? current;
    for (final prayer in Prayer.values) {
      if (!timeOf(prayer).isAfter(now)) current = prayer;
    }
    return current;
  }

  /// The next time (including sunrise) after [now] on this day, or null after Isha.
  Prayer? nextAfter(DateTime now) {
    for (final prayer in Prayer.values) {
      if (timeOf(prayer).isAfter(now)) return prayer;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    date,
    fajr,
    sunrise,
    dhuhr,
    asr,
    maghrib,
    isha,
    midnight,
    lastThird,
  ];
}

/// Computes prayer times from the sun's position.
///
/// Written in-house rather than taking a package: the maths is a few well-documented
/// formulas (Jean Meeus, *Astronomical Algorithms*, in the low-precision form used by
/// PrayTimes.org), accurate to well under a minute between the polar circles, and
/// owning it lets us test every method against published timetables.
///
/// Times are computed in UTC directly, so the result does not depend on the device's
/// time-zone database: a day's times are hours offset from UTC midnight of that date,
/// and the solar day is centred on the observer's longitude.
abstract final class PrayerCalculator {
  static PrayerTimes calculate({
    required Coordinates coordinates,
    required DateTime date,
    required CalculationParameters parameters,
  }) {
    final method = parameters.method;
    final lat = coordinates.latitude;
    final lng = coordinates.longitude;
    final jDate = _julian(date.year, date.month, date.day) - lng / (15 * 24);

    // Initial guesses in hours; one refinement pass re-evaluates the sun's position at
    // each guess, which is all the precision the low-order formulas can give.
    var t = _Times(
      fajr: 5,
      sunrise: 6,
      dhuhr: 12,
      asr: 13,
      sunset: 18,
      maghrib: 18,
      isha: 18,
    );
    final riseSetAngle =
        0.833 + 0.0347 * math.sqrt(math.max(0, coordinates.elevation));

    double midDay(double time) {
      final eqt = _sunPosition(jDate + time).equation;
      return _fixHour(12 - eqt);
    }

    double sunAngleTime(double angle, double time, {bool beforeNoon = false}) {
      final decl = _sunPosition(jDate + time).declination;
      final noon = midDay(time);
      final cosT =
          (-_dsin(angle) - _dsin(decl) * _dsin(lat)) /
          (_dcos(decl) * _dcos(lat));
      final hours = _darccos(cosT) / 15;
      return noon + (beforeNoon ? -hours : hours);
    }

    double asrTime(int factor, double time) {
      final decl = _sunPosition(jDate + time).declination;
      final angle = -_darccot(factor + _dtan((lat - decl).abs()));
      return sunAngleTime(angle, time);
    }

    final p = t.dividedBy(24);
    t = _Times(
      fajr: sunAngleTime(method.fajrAngle, p.fajr, beforeNoon: true),
      sunrise: sunAngleTime(riseSetAngle, p.sunrise, beforeNoon: true),
      dhuhr: midDay(p.dhuhr),
      asr: asrTime(parameters.madhab.shadowFactor, p.asr),
      sunset: sunAngleTime(riseSetAngle, p.sunset),
      maghrib: sunAngleTime(method.maghribAngle ?? riseSetAngle, p.maghrib),
      isha: sunAngleTime(method.ishaAngle ?? 18, p.isha),
    );

    // From local solar time to UTC hours.
    t = t.shifted(-lng / 15);

    if (method.ishaMinutes != null) {
      t = t.copyWith(isha: t.maghrib + method.ishaMinutes! / 60);
    }
    if (method.maghribAngle == null) t = t.copyWith(maghrib: t.sunset);
    t = _adjustHighLatitudes(t, parameters);

    final night = _timeDiff(t.sunset, t.sunrise);
    final midnight = method.jafariMidnight
        ? t.sunset + _timeDiff(t.sunset, t.fajr) / 2
        : t.sunset + night / 2;
    final lastThird = t.sunset + night * 2 / 3;

    final base = DateTime.utc(date.year, date.month, date.day);
    DateTime at(double hours, [Prayer? prayer]) {
      final minutes = prayer == null ? 0 : parameters.adjustmentFor(prayer);
      // Rounded to the minute: that is the precision every timetable publishes.
      final totalSeconds = (hours * 3600).round() + minutes * 60;
      final rounded = ((totalSeconds + 30) ~/ 60) * 60;
      return base.add(Duration(seconds: rounded));
    }

    return PrayerTimes(
      date: DateTime(date.year, date.month, date.day),
      fajr: at(t.fajr, Prayer.fajr),
      sunrise: at(t.sunrise, Prayer.sunrise),
      dhuhr: at(t.dhuhr, Prayer.dhuhr),
      asr: at(t.asr, Prayer.asr),
      maghrib: at(t.maghrib, Prayer.maghrib),
      isha: at(t.isha, Prayer.isha),
      midnight: at(midnight),
      lastThird: at(lastThird),
    );
  }

  /// Clamps Fajr and Isha to a portion of the night where the angle formula has no
  /// answer (NaN) or yields an implausibly long twilight.
  static _Times _adjustHighLatitudes(
    _Times t,
    CalculationParameters parameters,
  ) {
    final rule = parameters.highLatitudeRule;
    final method = parameters.method;
    if (rule == HighLatitudeRule.none) return t;
    final night = _timeDiff(t.sunset, t.sunrise);
    if (night.isNaN) return t;

    double portion(double angle) => switch (rule) {
      HighLatitudeRule.middleOfTheNight => 1 / 2,
      HighLatitudeRule.seventhOfTheNight => 1 / 7,
      HighLatitudeRule.twilightAngle => angle / 60,
      HighLatitudeRule.none => 1,
    };

    var fajr = t.fajr;
    final fajrLimit = portion(method.fajrAngle) * night;
    if (fajr.isNaN || _timeDiff(fajr, t.sunrise) > fajrLimit) {
      fajr = t.sunrise - fajrLimit;
    }

    var isha = t.isha;
    if (method.ishaMinutes == null) {
      final ishaLimit = portion(method.ishaAngle ?? 18) * night;
      if (isha.isNaN || _timeDiff(t.sunset, isha) > ishaLimit) {
        isha = t.sunset + ishaLimit;
      }
    }

    var maghrib = t.maghrib;
    if (method.maghribAngle != null) {
      final limit = portion(method.maghribAngle!) * night;
      if (maghrib.isNaN || _timeDiff(t.sunset, maghrib) > limit) {
        maghrib = t.sunset + limit;
      }
    }
    return t.copyWith(fajr: fajr, isha: isha, maghrib: maghrib);
  }

  /// Declination of the sun and the equation of time at Julian day [jd].
  static ({double declination, double equation}) _sunPosition(double jd) {
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

  static double _julian(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524.5;
  }

  static double _timeDiff(double from, double to) => _fixHour(to - from);

  static double _dsin(double d) => math.sin(d * math.pi / 180);
  static double _dcos(double d) => math.cos(d * math.pi / 180);
  static double _dtan(double d) => math.tan(d * math.pi / 180);
  static double _darcsin(double x) => math.asin(x) * 180 / math.pi;
  static double _darccos(double x) => math.acos(x) * 180 / math.pi;
  static double _darctan2(double y, double x) =>
      math.atan2(y, x) * 180 / math.pi;
  static double _darccot(double x) => math.atan(1 / x) * 180 / math.pi;

  static double _fixAngle(double a) => _fix(a, 360);
  static double _fixHour(double a) => _fix(a, 24);
  static double _fix(double a, double b) {
    final r = a - b * (a / b).floor();
    return r < 0 ? r + b : r;
  }
}

class _Times {
  const _Times({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
  });

  final double fajr, sunrise, dhuhr, asr, sunset, maghrib, isha;

  _Times dividedBy(double d) => _map((v) => v / d);
  _Times shifted(double hours) => _map((v) => v + hours);

  _Times _map(double Function(double) f) => _Times(
    fajr: f(fajr),
    sunrise: f(sunrise),
    dhuhr: f(dhuhr),
    asr: f(asr),
    sunset: f(sunset),
    maghrib: f(maghrib),
    isha: f(isha),
  );

  _Times copyWith({double? fajr, double? isha, double? maghrib}) => _Times(
    fajr: fajr ?? this.fajr,
    sunrise: sunrise,
    dhuhr: dhuhr,
    asr: asr,
    sunset: sunset,
    maghrib: maghrib ?? this.maghrib,
    isha: isha ?? this.isha,
  );
}
