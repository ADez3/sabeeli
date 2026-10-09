import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/prayer_settings.dart';
import '../models/prayer_settings_model.dart';

@lazySingleton
class PrayerSettingsLocalDataSource {
  const PrayerSettingsLocalDataSource(this._store);
  final KeyValueStore _store;

  static const _key = 'prayer.settings';

  PrayerSettings read() {
    final json = _store.getJson(_key);
    return json == null
        ? const PrayerSettings()
        : PrayerSettingsModel.fromJson(json);
  }

  Future<void> write(PrayerSettings settings) =>
      _store.setJson(_key, PrayerSettingsModel.toJson(settings));
}
