import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/land_mask.dart';
import '../repositories/qibla_repository.dart';

@injectable
class GetLandMaskUseCase implements UseCase<LandMask, NoParams> {
  const GetLandMaskUseCase(this._repository);
  final QiblaRepository _repository;

  @override
  Future<Result<LandMask>> call(NoParams params) => _repository.landMask();
}
