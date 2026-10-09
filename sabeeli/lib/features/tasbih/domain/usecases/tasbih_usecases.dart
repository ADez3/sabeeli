import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tasbih_state_data.dart';
import '../repositories/tasbih_repository.dart';

@injectable
class LoadTasbihUseCase implements UseCase<TasbihData, NoParams> {
  const LoadTasbihUseCase(this._repository);
  final TasbihRepository _repository;

  @override
  Future<Result<TasbihData>> call(NoParams params) => _repository.load();
}

@injectable
class SaveTasbihUseCase implements UseCase<void, TasbihData> {
  const SaveTasbihUseCase(this._repository);
  final TasbihRepository _repository;

  @override
  Future<Result<void>> call(TasbihData params) => _repository.save(params);
}
