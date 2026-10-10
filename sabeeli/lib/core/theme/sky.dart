import 'package:flutter/painting.dart';

/// Three colours of a sky: zenith, middle and horizon.
class SkyColors {
  const SkyColors(this.top, this.middle, this.horizon);

  final Color top;
  final Color middle;
  final Color horizon;

  List<Color> get gradient => [top, middle, horizon];

  @override
  bool operator ==(Object other) =>
      other is SkyColors &&
      other.top == top &&
      other.middle == middle &&
      other.horizon == horizon;

  @override
  int get hashCode => Object.hash(top, middle, horizon);

  static SkyColors lerp(SkyColors a, SkyColors b, double t) => SkyColors(
    Color.lerp(a.top, b.top, t)!,
    Color.lerp(a.middle, b.middle, t)!,
    Color.lerp(a.horizon, b.horizon, t)!,
  );
}

/// The colour of the sky from the sun's altitude: deep night, the blues of
/// twilight, a warm horizon at sunrise and a redder one at sunset, then daylight.
abstract final class SkyPalette {
  static const _night = SkyColors(
    Color(0xFF04060F),
    Color(0xFF0A0E2A),
    Color(0xFF161A42),
  );
  static const _astronomical = SkyColors(
    Color(0xFF070A20),
    Color(0xFF151A48),
    Color(0xFF2E2A62),
  );
  static const _dawnBlue = SkyColors(
    Color(0xFF121B48),
    Color(0xFF353877),
    Color(0xFFA86C86),
  );
  static const _duskBlue = SkyColors(
    Color(0xFF100E36),
    Color(0xFF43285F),
    Color(0xFFB84C4C),
  );
  static const _sunrise = SkyColors(
    Color(0xFF1F3B78),
    Color(0xFF6468A2),
    Color(0xFFEFA27C),
  );
  static const _sunset = SkyColors(
    Color(0xFF1B2762),
    Color(0xFF744676),
    Color(0xFFEE7746),
  );
  static const _lowMorning = SkyColors(
    Color(0xFF285BA4),
    Color(0xFF6C9BD3),
    Color(0xFFF2C78E),
  );
  static const _lowEvening = SkyColors(
    Color(0xFF26488E),
    Color(0xFF8676A2),
    Color(0xFFEE9E5C),
  );
  static const _day = SkyColors(
    Color(0xFF2560B7),
    Color(0xFF5590D6),
    Color(0xFFA6CBEE),
  );
  static const _highDay = SkyColors(
    Color(0xFF1C58BC),
    Color(0xFF468AD9),
    Color(0xFF98C4F0),
  );

  /// [morning]: the sun is rising (before solar noon). Sunrise and sunset share
  /// altitudes but not colours.
  static SkyColors at(double altitude, {required bool morning}) {
    final stops = <(double, SkyColors)>[
      (-18, _night),
      (-12, _astronomical),
      (-6, morning ? _dawnBlue : _duskBlue),
      (0, morning ? _sunrise : _sunset),
      (6, morning ? _lowMorning : _lowEvening),
      (16, _day),
      (45, _highDay),
    ];
    if (altitude <= stops.first.$1) return stops.first.$2;
    for (var i = 1; i < stops.length; i++) {
      final (a, ca) = stops[i - 1];
      final (b, cb) = stops[i];
      if (altitude <= b) {
        return SkyColors.lerp(ca, cb, (altitude - a) / (b - a));
      }
    }
    return stops.last.$2;
  }

  /// Stars fade in as the sky darkens after sunset.
  static double starOpacity(double altitude) =>
      ((-altitude - 4) / 10).clamp(0.0, 1.0);
}
