import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/compass_reading.dart';
import '../repositories/qibla_repository.dart';

@injectable
class WatchCompassUseCase
    implements StreamUseCase<CompassReading, Coordinates?> {
  const WatchCompassUseCase(this._repository);
  final QiblaRepository _repository;

  @override
  Stream<Result<CompassReading>> call(Coordinates? params) =>
      _repository.compass(params);
}
