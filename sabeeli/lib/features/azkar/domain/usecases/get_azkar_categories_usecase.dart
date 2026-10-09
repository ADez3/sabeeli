import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/azkar_entities.dart';
import '../repositories/azkar_repository.dart';

@injectable
class GetAzkarCategoriesUseCase
    implements UseCase<List<AzkarCategory>, NoParams> {
  const GetAzkarCategoriesUseCase(this._repository);
  final AzkarRepository _repository;

  @override
  Future<Result<List<AzkarCategory>>> call(NoParams params) =>
      _repository.categories();
}
