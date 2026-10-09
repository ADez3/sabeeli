import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/error/exceptions.dart';

@lazySingleton
class DeviceLocationDataSource {
  /// A position good to a few kilometres is all prayer times need (a minute of
  /// difference is ~25 km of longitude), so low accuracy is requested: it answers
  /// faster, works indoors and costs less battery.
  Future<Coordinates> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationDisabledException('Location services are off');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    switch (permission) {
      case LocationPermission.denied:
        throw const LocationPermissionException('Denied');
      case LocationPermission.deniedForever:
        throw const LocationPermissionException(
          'Denied forever',
          permanently: true,
        );
      case LocationPermission.whileInUse || LocationPermission.always:
      case LocationPermission.unableToDetermine:
        break;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return _toCoordinates(position);
    } catch (_) {
      // Indoors or with a cold GPS a fresh fix can time out; the last known position
      // is almost always the same city.
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return _toCoordinates(last);
      rethrow;
    }
  }

  Future<void> openAppSettings() => Geolocator.openAppSettings();
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  static Coordinates _toCoordinates(Position p) => Coordinates(
    latitude: p.latitude,
    longitude: p.longitude,
    elevation: p.altitude,
  );
}
