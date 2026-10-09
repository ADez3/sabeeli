import 'package:injectable/injectable.dart';

import '../../../../core/hijri/hijri_calendar.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hijri_settings.dart';
import '../repositories/hijri_repository.dart';

@injectable
class LoadHijriSettingsUseCase implements UseCase<HijriSettings, NoParams> {
  const LoadHijriSettingsUseCase(this._repository);
  final HijriRepository _repository;

  @override
  Future<Result<HijriSettings>> call(NoParams params) =>
      _repository.loadSettings();
}

@injectable
class SaveHijriSettingsUseCase implements UseCase<void, HijriSettings> {
  const SaveHijriSettingsUseCase(this._repository);
  final HijriRepository _repository;

  @override
  Future<Result<void>> call(HijriSettings params) =>
      _repository.saveSettings(params);
}

@injectable
class BuildHijriCalendarUseCase
    implements UseCase<HijriCalendar, HijriSettings> {
  const BuildHijriCalendarUseCase(this._repository);
  final HijriRepository _repository;

  @override
  Future<Result<HijriCalendar>> call(HijriSettings params) =>
      _repository.calendarFor(params);
}
