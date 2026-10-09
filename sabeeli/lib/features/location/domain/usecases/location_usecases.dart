import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_location.dart';
import '../repositories/location_repository.dart';

class LanguageParams extends Equatable {
  const LanguageParams(this.language);

  /// Language for place names.
  final String language;

  @override
  List<Object?> get props => [language];
}

class SearchPlacesParams extends Equatable {
  const SearchPlacesParams({required this.query, required this.language});
  final String query;
  final String language;

  @override
  List<Object?> get props => [query, language];
}

@injectable
class GetSavedLocationUseCase implements UseCase<SavedLocation?, NoParams> {
  const GetSavedLocationUseCase(this._repository);
  final LocationRepository _repository;

  @override
  Future<Result<SavedLocation?>> call(NoParams params) => _repository.saved();
}

@injectable
class LocateDeviceUseCase implements UseCase<SavedLocation, LanguageParams> {
  const LocateDeviceUseCase(this._repository);
  final LocationRepository _repository;

  @override
  Future<Result<SavedLocation>> call(LanguageParams params) =>
      _repository.locateDevice(language: params.language);
}

@injectable
class SearchPlacesUseCase
    implements UseCase<List<SavedLocation>, SearchPlacesParams> {
  const SearchPlacesUseCase(this._repository);
  final LocationRepository _repository;

  @override
  Future<Result<List<SavedLocation>>> call(SearchPlacesParams params) =>
      _repository.search(params.query, language: params.language);
}

@injectable
class SaveLocationUseCase implements UseCase<void, SavedLocation> {
  const SaveLocationUseCase(this._repository);
  final LocationRepository _repository;

  @override
  Future<Result<void>> call(SavedLocation params) => _repository.save(params);
}
