import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dhikr_step.dart';
import '../repositories/azkar_repository.dart';

/// The steps said after [Prayer], in order (some are for Fajr or Maghrib only).
@injectable
class GetAfterPrayerStepsUseCase implements UseCase<List<DhikrStep>, Prayer> {
  const GetAfterPrayerStepsUseCase(this._repository);
  final AzkarRepository _repository;

  @override
  Future<Result<List<DhikrStep>>> call(Prayer prayer) async =>
      (await _repository.afterPrayer()).map(
        (steps) => [
          for (final s in steps)
            if (s.saidAfter(prayer)) s,
        ],
      );
}
