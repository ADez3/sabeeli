import '../../../../core/result/result.dart';
import '../entities/quran_entities.dart';

abstract interface class QuranRepository {
  /// Loads [riwayah]'s mushaf; later calls convert to and from its numbering.
  Future<Result<QuranData>> load(Riwayah riwayah);

  /// Every edition that can be shown: the bundled ones first, then the catalogue.
  Future<Result<List<QuranEdition>>> editions();

  /// The text of [edition] for [ref], or null when it is not downloaded yet.
  Future<Result<String?>> editionText(QuranEdition edition, AyahRef ref);
  Future<Result<void>> downloadEdition(QuranEdition edition);

  Future<Result<List<Bookmark>>> bookmarks();
  Future<Result<List<Bookmark>>> toggleBookmark(AyahRef ref);

  Future<Result<ReadingPosition?>> position();
  Future<Result<void>> savePosition(ReadingPosition position);

  Future<Result<ReaderPreferences>> preferences();

  Future<Result<Set<int>>> readPages();

  /// Adds [page] to the pages read and returns the updated set.
  Future<Result<Set<int>>> markPageRead(int page);
  Future<Result<void>> savePreferences(ReaderPreferences preferences);

  /// Days on which a page was read; today is added by [markPageRead].
  Future<Result<Set<DateTime>>> readDays();

  Future<Result<KhatmahPlan?>> plan();
  Future<Result<void>> savePlan(KhatmahPlan? plan);
}
