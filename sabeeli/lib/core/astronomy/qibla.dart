import 'dart:math' as math;

import 'coordinates.dart';

abstract final class Qibla {
  static const kaaba = Coordinates(latitude: 21.4224779, longitude: 39.8251832);

  /// Initial great-circle bearing from [from] to the Kaaba, in degrees clockwise from
  /// true north. This is the direction of prayer: the shortest path over the globe,
  /// not the straight line on a flat map.
  static double bearingFrom(Coordinates from) {
    final phi = _rad(from.latitude);
    final phiK = _rad(kaaba.latitude);
    final dLambda = _rad(kaaba.longitude - from.longitude);
    final y = math.sin(dLambda);
    final x =
        math.cos(phi) * math.tan(phiK) - math.sin(phi) * math.cos(dLambda);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  static double distanceKm(Coordinates from) => from.distanceTo(kaaba);

  /// Points along the great circle from [from] to the Kaaba, both ends included:
  /// the path a prayer faces along, for drawing on a globe.
  static List<Coordinates> pathFrom(Coordinates from, {int steps = 64}) {
    final a = _vector(from);
    final b = _vector(kaaba);
    final dot = (a.$1 * b.$1 + a.$2 * b.$2 + a.$3 * b.$3).clamp(-1.0, 1.0);
    final omega = math.acos(dot);
    if (omega < 1e-9) return [from, kaaba];
    final sinOmega = math.sin(omega);
    return [
      for (var i = 0; i <= steps; i++)
        () {
          final t = i / steps;
          final wa = math.sin((1 - t) * omega) / sinOmega;
          final wb = math.sin(t * omega) / sinOmega;
          final x = wa * a.$1 + wb * b.$1;
          final y = wa * a.$2 + wb * b.$2;
          final z = wa * a.$3 + wb * b.$3;
          return Coordinates(
            latitude: math.atan2(z, math.sqrt(x * x + y * y)) * 180 / math.pi,
            longitude: math.atan2(y, x) * 180 / math.pi,
          );
        }(),
    ];
  }

  static (double, double, double) _vector(Coordinates c) {
    final phi = _rad(c.latitude);
    final lambda = _rad(c.longitude);
    return (
      math.cos(phi) * math.cos(lambda),
      math.cos(phi) * math.sin(lambda),
      math.sin(phi),
    );
  }

  static double _rad(double d) => d * math.pi / 180;
}
