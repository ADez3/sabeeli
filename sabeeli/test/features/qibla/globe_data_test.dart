import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/astronomy/coordinates.dart';
import 'package:sabeeli/core/astronomy/qibla.dart';
import 'package:sabeeli/features/qibla/domain/entities/land_mask.dart';

void main() {
  test(
    'the Qibla path runs from the user to the Kaaba along a great circle',
    () {
      const london = Coordinates(latitude: 51.5074, longitude: -0.1278);
      final path = Qibla.pathFrom(london, steps: 50);
      expect(path, hasLength(51));
      expect(path.first.latitude, closeTo(london.latitude, 1e-6));
      expect(path.last.latitude, closeTo(Qibla.kaaba.latitude, 1e-6));
      expect(path.last.longitude, closeTo(Qibla.kaaba.longitude, 1e-6));
      // Every step is the same length on a great circle.
      final first = path[0].distanceTo(path[1]);
      final mid = path[25].distanceTo(path[26]);
      expect(mid, closeTo(first, 0.5));
      // And the whole path is as long as the direct distance.
      var total = 0.0;
      for (var i = 1; i < path.length; i++) {
        total += path[i - 1].distanceTo(path[i]);
      }
      expect(total, closeTo(Qibla.distanceKm(london), 1));
    },
  );

  test('the land mask knows land from sea', () {
    final json = jsonDecode(
      File('assets/geo/land_mask.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final mask = LandMask(
      width: json['w'] as int,
      height: json['h'] as int,
      bits: base64Decode(json['bits'] as String),
    );
    expect(mask.isLand(23, 10), isTrue); // Sahara
    expect(mask.isLand(21.4, 39.8), isTrue); // Makkah
    expect(mask.isLand(-25, 134), isTrue); // Australia
    expect(mask.isLand(30, -40), isFalse); // North Atlantic
    expect(mask.isLand(0, -150), isFalse); // Pacific
  });
}
