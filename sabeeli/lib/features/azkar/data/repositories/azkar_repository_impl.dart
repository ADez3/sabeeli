import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/after_prayer.dart';
import '../../domain/entities/azkar_entities.dart';
import '../../domain/repositories/azkar_repository.dart';
import '../datasources/azkar_asset_data_source.dart';

@LazySingleton(as: AzkarRepository)
class AzkarRepositoryImpl implements AzkarRepository {
  const AzkarRepositoryImpl(this._assets);
  final AzkarAssetDataSource _assets;

  @override
  Future<Result<List<AzkarCategory>>> categories() async {
    try {
      return Ok(await _assets.load());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<List<AfterPrayerStep>>> afterPrayer() async {
    try {
      return Ok(await _assets.afterPrayer());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }
}
