import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

@injectable
class LoadAppSettingsUseCase implements UseCase<AppSettings, NoParams> {
  const LoadAppSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  @override
  Future<Result<AppSettings>> call(NoParams params) => _repository.load();
}

@injectable
class SaveAppSettingsUseCase implements UseCase<void, AppSettings> {
  const SaveAppSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(AppSettings params) => _repository.save(params);
}
