import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/quran_entities.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_asset_data_source.dart';
import '../datasources/quran_local_data_source.dart';
import '../datasources/translation_remote_data_source.dart';

@LazySingleton(as: QuranRepository)
class QuranRepositoryImpl implements QuranRepository {
  const QuranRepositoryImpl(this._assets, this._local, this._remote);

  final QuranAssetDataSource _assets;
  final QuranLocalDataSource _local;
  final TranslationRemoteDataSource _remote;

  @override
  Future<Result<QuranData>> load() => _guard(_assets.load);

  @override
  Future<Result<List<QuranEdition>>> editions() => _guard(
    () async => [
      ...QuranAssetDataSource.bundledEditions,
      ...await _assets.catalog(),
    ],
  );

  @override
  Future<Result<String?>> editionText(QuranEdition edition, AyahRef ref) =>
      _guard(() async {
        final data = await _assets.load();
        final list = edition.isBundled
            ? await _assets.bundledEdition(edition.id)
            : await _remote.cached(edition.id);
        return list?[data.flatIndex(ref)];
      });

  @override
  Future<Result<void>> downloadEdition(QuranEdition edition) =>
      _guard(() => _remote.download(edition));

  @override
  Future<Result<List<Bookmark>>> bookmarks() =>
      _guard(() async => _local.bookmarks());

  @override
  Future<Result<List<Bookmark>>> toggleBookmark(AyahRef ref) =>
      _guard(() async {
        final list = _local.bookmarks();
        final exists = list.any((b) => b.ref == ref);
        final next = exists
            ? list.where((b) => b.ref != ref).toList()
            : [Bookmark(ref: ref, createdAt: DateTime.now()), ...list];
        await _local.saveBookmarks(next);
        return next;
      });

  @override
  Future<Result<ReadingPosition?>> position() =>
      _guard(() async => _local.position());

  @override
  Future<Result<void>> savePosition(ReadingPosition position) =>
      _guard(() => _local.savePosition(position));

  @override
  Future<Result<Set<int>>> readPages() =>
      _guard(() async => _local.readPages());

  @override
  Future<Result<Set<int>>> markPageRead(int page) => _guard(() async {
    final pages = _local.readPages();
    if (pages.add(page)) await _local.saveReadPages(pages);
    return pages;
  });

  @override
  Future<Result<ReaderPreferences>> preferences() =>
      _guard(() async => _local.preferences());

  @override
  Future<Result<void>> savePreferences(ReaderPreferences preferences) =>
      _guard(() => _local.savePreferences(preferences));

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }
}
