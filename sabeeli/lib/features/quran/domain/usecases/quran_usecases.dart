import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_entities.dart';
import '../repositories/quran_repository.dart';

class EditionTextParams extends Equatable {
  const EditionTextParams(this.edition, this.ref);
  final QuranEdition edition;
  final AyahRef ref;

  @override
  List<Object?> get props => [edition, ref];
}

@injectable
class LoadQuranUseCase implements UseCase<QuranData, NoParams> {
  const LoadQuranUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<QuranData>> call(NoParams params) => _repository.load();
}

@injectable
class GetEditionsUseCase implements UseCase<List<QuranEdition>, NoParams> {
  const GetEditionsUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<List<QuranEdition>>> call(NoParams params) =>
      _repository.editions();
}

@injectable
class GetEditionTextUseCase implements UseCase<String?, EditionTextParams> {
  const GetEditionTextUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<String?>> call(EditionTextParams params) =>
      _repository.editionText(params.edition, params.ref);
}

@injectable
class DownloadEditionUseCase implements UseCase<void, QuranEdition> {
  const DownloadEditionUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<void>> call(QuranEdition params) =>
      _repository.downloadEdition(params);
}

@injectable
class GetBookmarksUseCase implements UseCase<List<Bookmark>, NoParams> {
  const GetBookmarksUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<List<Bookmark>>> call(NoParams params) =>
      _repository.bookmarks();
}

@injectable
class ToggleBookmarkUseCase implements UseCase<List<Bookmark>, AyahRef> {
  const ToggleBookmarkUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<List<Bookmark>>> call(AyahRef params) =>
      _repository.toggleBookmark(params);
}

@injectable
class GetReadingPositionUseCase implements UseCase<ReadingPosition?, NoParams> {
  const GetReadingPositionUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<ReadingPosition?>> call(NoParams params) =>
      _repository.position();
}

@injectable
class SaveReadingPositionUseCase implements UseCase<void, ReadingPosition> {
  const SaveReadingPositionUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<void>> call(ReadingPosition params) =>
      _repository.savePosition(params);
}

@injectable
class GetReaderPreferencesUseCase
    implements UseCase<ReaderPreferences, NoParams> {
  const GetReaderPreferencesUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<ReaderPreferences>> call(NoParams params) =>
      _repository.preferences();
}

@injectable
class SaveReaderPreferencesUseCase implements UseCase<void, ReaderPreferences> {
  const SaveReaderPreferencesUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<void>> call(ReaderPreferences params) =>
      _repository.savePreferences(params);
}

@injectable
class GetReadPagesUseCase implements UseCase<Set<int>, NoParams> {
  const GetReadPagesUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<Set<int>>> call(NoParams params) => _repository.readPages();
}

@injectable
class MarkPageReadUseCase implements UseCase<Set<int>, int> {
  const MarkPageReadUseCase(this._repository);
  final QuranRepository _repository;

  @override
  Future<Result<Set<int>>> call(int params) => _repository.markPageRead(params);
}
