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

  static double _rad(double d) => d * math.pi / 180;
}
