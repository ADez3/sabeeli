import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/tasbih_state_data.dart';
import '../../domain/repositories/tasbih_repository.dart';
import '../datasources/tasbih_local_data_source.dart';

@LazySingleton(as: TasbihRepository)
class TasbihRepositoryImpl implements TasbihRepository {
  const TasbihRepositoryImpl(this._local);
  final TasbihLocalDataSource _local;

  @override
  Future<Result<TasbihData>> load() async {
    try {
      return Ok(_local.read());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> save(TasbihData data) async {
    try {
      await _local.write(data);
      return const Ok(null);
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }
}
