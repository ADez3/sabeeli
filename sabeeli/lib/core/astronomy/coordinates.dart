import 'dart:math' as math;

import 'package:equatable/equatable.dart';

class Coordinates extends Equatable {
  const Coordinates({
    required this.latitude,
    required this.longitude,
    this.elevation = 0,
  });

  final double latitude;
  final double longitude;

  /// Metres above sea level. Raises the horizon slightly, so sunrise is earlier and
  /// sunset later on a mountain; zero is the safe default for cities.
  final double elevation;

  /// Great-circle distance in kilometres (haversine).
  double distanceTo(Coordinates other) {
    const earthRadiusKm = 6371.0;
    final dLat = _rad(other.latitude - latitude);
    final dLng = _rad(other.longitude - longitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(latitude)) *
            math.cos(_rad(other.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * earthRadiusKm * math.asin(math.min(1, math.sqrt(a)));
  }

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  List<Object?> get props => [latitude, longitude, elevation];
}
