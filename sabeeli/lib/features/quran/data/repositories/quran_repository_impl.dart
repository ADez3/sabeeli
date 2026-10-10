import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/quran_entities.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_asset_data_source.dart';
import '../datasources/quran_local_data_source.dart';
import '../datasources/translation_remote_data_source.dart';

/// Bookmarks and the reading position are stored in Hafs numbering, the common
/// reference, and converted here to and from the riwayah being read; so are the
/// Hafs-indexed tafsir and translations. Nothing above this class has to care.
@LazySingleton(as: QuranRepository)
class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(this._assets, this._local, this._remote);

  final QuranAssetDataSource _assets;
  final QuranLocalDataSource _local;
  final TranslationRemoteDataSource _remote;

  /// The mushaf being read; Hafs until another is loaded.
  QuranData? _current;

  Future<QuranData> _data() async =>
      _current ??= await _assets.load(Riwayah.hafs);

  @override
  Future<Result<QuranData>> load(Riwayah riwayah) =>
      _guard(() async => _current = await _assets.load(riwayah));

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
        final data = await _data();
        final list = edition.isBundled
            ? await _assets.bundledEdition(edition.id)
            : await _remote.cached(edition.id);
        if (list == null) return null;
        // An ayah of another riwayah can span several Hafs ayahs; consecutive
        // identical entries are one passage (as in al-Muyassar).
        final parts = <String>[];
        for (final i in data.hafsIndicesOf(ref)) {
          if (parts.isEmpty || parts.last != list[i]) parts.add(list[i]);
        }
        return parts.join('\n\n');
      });

  @override
  Future<Result<void>> downloadEdition(QuranEdition edition) =>
      _guard(() => _remote.download(edition));

  @override
  Future<Result<List<Bookmark>>> bookmarks() =>
      _guard(() async => _fromHafs(await _data(), _local.bookmarks()));

  @override
  Future<Result<List<Bookmark>>> toggleBookmark(AyahRef ref) =>
      _guard(() async {
        final data = await _data();
        final hafs = data.toHafs(ref);
        final list = _local.bookmarks();
        final exists = list.any((b) => b.ref == hafs);
        final next = exists
            ? list.where((b) => b.ref != hafs).toList()
            : [Bookmark(ref: hafs, createdAt: DateTime.now()), ...list];
        await _local.saveBookmarks(next);
        return _fromHafs(data, next);
      });

  static List<Bookmark> _fromHafs(QuranData data, List<Bookmark> list) => [
    for (final b in list)
      Bookmark(ref: data.fromHafs(b.ref), createdAt: b.createdAt),
  ];

  @override
  Future<Result<ReadingPosition?>> position() => _guard(() async {
    final stored = _local.position();
    if (stored == null) return null;
    final data = await _data();
    final ref = data.fromHafs(stored.ref);
    return ReadingPosition(
      ref: ref,
      page: data.pageOf(ref),
      updatedAt: stored.updatedAt,
    );
  });

  @override
  Future<Result<void>> savePosition(ReadingPosition position) =>
      _guard(() async {
        final data = await _data();
        await _local.savePosition(
          ReadingPosition(
            ref: data.toHafs(position.ref),
            page: position.page,
            updatedAt: position.updatedAt,
          ),
        );
      });

  @override
  Future<Result<Set<int>>> readPages() =>
      _guard(() async => _local.readPages());

  @override
  Future<Result<Set<int>>> markPageRead(int page) => _guard(() async {
    final pages = _local.readPages();
    if (pages.add(page)) await _local.saveReadPages(pages);
    final now = DateTime.now();
    final days = _local.readDays();
    if (days.add(DateTime(now.year, now.month, now.day))) {
      await _local.saveReadDays(days);
    }
    return pages;
  });

  @override
  Future<Result<Set<DateTime>>> readDays() =>
      _guard(() async => _local.readDays());

  @override
  Future<Result<KhatmahPlan?>> plan() => _guard(() async => _local.plan());

  @override
  Future<Result<void>> savePlan(KhatmahPlan? plan) =>
      _guard(() => _local.savePlan(plan));

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
