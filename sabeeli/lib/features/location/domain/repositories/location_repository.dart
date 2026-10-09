import '../../../../core/result/result.dart';
import '../entities/saved_location.dart';

abstract interface class LocationRepository {
  /// The stored location, or null on first launch.
  Future<Result<SavedLocation?>> saved();

  /// Reads the device position, names it when the network allows, and stores it.
  Future<Result<SavedLocation>> locateDevice({required String language});

  Future<Result<List<SavedLocation>>> search(
    String query, {
    required String language,
  });

  Future<Result<void>> save(SavedLocation location);

  Future<void> openAppSettings();
  Future<void> openLocationSettings();
}
