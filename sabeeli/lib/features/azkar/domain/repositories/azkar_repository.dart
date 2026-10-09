import '../../../../core/result/result.dart';
import '../entities/azkar_entities.dart';

abstract interface class AzkarRepository {
  Future<Result<List<AzkarCategory>>> categories();
}
