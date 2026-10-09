import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);
  final SettingsLocalDataSource _local;

  @override
  Future<Result<AppSettings>> load() async {
    try {
      return Ok(_local.read());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> save(AppSettings settings) async {
    try {
      await _local.write(settings);
      return const Ok(null);
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }
}
