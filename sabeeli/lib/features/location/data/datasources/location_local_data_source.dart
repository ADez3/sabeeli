import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/saved_location.dart';
import '../models/saved_location_model.dart';

@lazySingleton
class LocationLocalDataSource {
  const LocationLocalDataSource(this._store);
  final KeyValueStore _store;

  static const _key = 'location.saved';

  SavedLocation? read() {
    final json = _store.getJson(_key);
    return json == null ? null : SavedLocationModel.fromJson(json);
  }

  Future<void> write(SavedLocation location) =>
      _store.setJson(_key, SavedLocationModel.toJson(location));
}
