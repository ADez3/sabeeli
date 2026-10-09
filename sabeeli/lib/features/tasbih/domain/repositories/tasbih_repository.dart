import '../../../../core/result/result.dart';
import '../entities/tasbih_state_data.dart';

abstract interface class TasbihRepository {
  Future<Result<TasbihData>> load();
  Future<Result<void>> save(TasbihData data);
}
