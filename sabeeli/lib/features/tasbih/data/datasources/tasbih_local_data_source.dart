import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/tasbih_state_data.dart';

@lazySingleton
class TasbihLocalDataSource {
  const TasbihLocalDataSource(this._store);
  final KeyValueStore _store;

  static const _key = 'tasbih.state';

  TasbihData read() {
    final json = _store.getJson(_key);
    return json == null ? const TasbihData() : TasbihData.fromJson(json);
  }

  Future<void> write(TasbihData data) => _store.setJson(_key, data.toJson());
}
