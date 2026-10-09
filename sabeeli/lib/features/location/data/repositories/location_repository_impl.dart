import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/saved_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/device_location_data_source.dart';
import '../datasources/geocoding_remote_data_source.dart';
import '../datasources/location_local_data_source.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl(this._device, this._geocoding, this._local);

  final DeviceLocationDataSource _device;
  final GeocodingRemoteDataSource _geocoding;
  final LocationLocalDataSource _local;

  @override
  Future<Result<SavedLocation?>> saved() => _guard(() async => _local.read());

  @override
  Future<Result<SavedLocation>> locateDevice({required String language}) =>
      _guard(() async {
        final coordinates = await _device.current();
        var location = SavedLocation(coordinates: coordinates);
        final previous = _local.read();
        try {
          location = await _geocoding.reverse(coordinates, language: language);
        } catch (_) {
          // Naming the place is cosmetic. Offline, keep the previous name and country
          // if the user has not moved far, so the method choice is not lost.
          if (previous != null &&
              previous.coordinates.distanceTo(coordinates) < 30) {
            location = SavedLocation(
              coordinates: coordinates,
              name: previous.name,
              countryCode: previous.countryCode,
            );
          }
        }
        await _local.write(location);
        return location;
      });

  @override
  Future<Result<List<SavedLocation>>> search(
    String query, {
    required String language,
  }) => _guard(() => _geocoding.search(query, language: language));

  @override
  Future<Result<void>> save(SavedLocation location) =>
      _guard(() => _local.write(location));

  @override
  Future<void> openAppSettings() => _device.openAppSettings();

  @override
  Future<void> openLocationSettings() => _device.openLocationSettings();

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }
}
