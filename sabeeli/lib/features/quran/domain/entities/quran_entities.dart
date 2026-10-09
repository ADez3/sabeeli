import 'package:equatable/equatable.dart';

/// One ayah's address. Ordered as in the mushaf.
class AyahRef extends Equatable implements Comparable<AyahRef> {
  const AyahRef(this.surah, this.ayah);

  final int surah;
  final int ayah;

  @override
  int compareTo(AyahRef other) => surah != other.surah
      ? surah.compareTo(other.surah)
      : ayah.compareTo(other.ayah);

  bool operator <(AyahRef other) => compareTo(other) < 0;
  bool operator <=(AyahRef other) => compareTo(other) <= 0;

  @override
  List<Object?> get props => [surah, ayah];

  @override
  String toString() => '$surah:$ayah';
}

enum Revelation { meccan, medinan }

class SurahInfo extends Equatable {
  const SurahInfo({
    required this.number,
    required this.nameArabic,
    required this.nameTransliterated,
    required this.nameEnglish,
    required this.revelation,
    required this.ayahCount,
    required this.startPage,
  });

  final int number;
  final String nameArabic;
  final String nameTransliterated;
  final String nameEnglish;
  final Revelation revelation;
  final int ayahCount;
  final int startPage;

  /// Every surah but Al-Fatihah (whose first ayah *is* the basmala) and At-Tawbah
  /// opens with a basmala that is not numbered as an ayah.
  bool get hasBasmalaHeader => number != 1 && number != 9;

  @override
  List<Object?> get props => [number];
}

class SajdaInfo extends Equatable {
  const SajdaInfo(this.ref, {required this.obligatory});
  final AyahRef ref;
  final bool obligatory;

  @override
  List<Object?> get props => [ref, obligatory];
}

/// The whole mushaf: text and structure, loaded once and kept in memory (~2 MB).
class QuranData {
  QuranData({
    required this.ayahs,
    required this.surahs,
    required this.juzStarts,
    required this.hizbQuarterStarts,
    required this.pageStarts,
    required this.sajdas,
  }) : _offsets = _prefixSums(surahs);

  /// `ayahs[s - 1][a - 1]`, verbatim KFGQPC Hafs text without the end marker.
  final List<List<String>> ayahs;
  final List<SurahInfo> surahs;
  final List<AyahRef> juzStarts;
  final List<AyahRef> hizbQuarterStarts;

  /// First ayah of each of the 604 pages of the Madani mushaf.
  final List<AyahRef> pageStarts;
  final List<SajdaInfo> sajdas;

  final List<int> _offsets;

  static const pageCount = 604;
  static const ayahTotal = 6236;

  static List<int> _prefixSums(List<SurahInfo> surahs) {
    final out = <int>[0];
    for (final s in surahs) {
      out.add(out.last + s.ayahCount);
    }
    return out;
  }

  SurahInfo surah(int number) => surahs[number - 1];

  String text(AyahRef ref) => ayahs[ref.surah - 1][ref.ayah - 1];

  /// 0-based position of an ayah in the whole Quran (0…6235).
  int flatIndex(AyahRef ref) => _offsets[ref.surah - 1] + ref.ayah - 1;

  AyahRef fromFlatIndex(int index) {
    var s = 0;
    while (_offsets[s + 1] <= index) {
      s++;
    }
    return AyahRef(s + 1, index - _offsets[s] + 1);
  }

  /// The last element of [starts] that is ≤ [ref], 1-based.
  static int _sectionOf(List<AyahRef> starts, AyahRef ref) {
    var lo = 0, hi = starts.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (starts[mid] <= ref) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo + 1;
  }

  int pageOf(AyahRef ref) => _sectionOf(pageStarts, ref);
  int juzOf(AyahRef ref) => _sectionOf(juzStarts, ref);

  /// 1…240: each juz has two hizbs of four quarters.
  int hizbQuarterOf(AyahRef ref) => _sectionOf(hizbQuarterStarts, ref);

  /// Every ayah on a page, in order.
  List<AyahRef> ayahsOnPage(int page) {
    final start = flatIndex(pageStarts[page - 1]);
    final end = page < pageCount ? flatIndex(pageStarts[page]) : ayahTotal;
    return [for (var i = start; i < end; i++) fromFlatIndex(i)];
  }

  SajdaInfo? sajdaAt(AyahRef ref) {
    for (final s in sajdas) {
      if (s.ref == ref) return s;
    }
    return null;
  }
}

class Bookmark extends Equatable {
  const Bookmark({required this.ref, required this.createdAt});
  final AyahRef ref;
  final DateTime createdAt;

  @override
  List<Object?> get props => [ref, createdAt];
}

/// Where the reader stopped. [ref] is the ayah the user marked or the first ayah of
/// the last page they had open.
class ReadingPosition extends Equatable {
  const ReadingPosition({
    required this.ref,
    required this.page,
    required this.updatedAt,
  });
  final AyahRef ref;
  final int page;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [ref, page, updatedAt];
}

/// A translation or tafsir that can be shown under an ayah.
class QuranEdition extends Equatable {
  const QuranEdition({
    required this.id,
    required this.languageCode,
    required this.name,
    required this.isTafsir,
    required this.isRtl,
    this.url,
    this.fallbackUrl,
  });

  final String id;
  final String languageCode;
  final String name;
  final bool isTafsir;
  final bool isRtl;

  /// Null for editions bundled with the app.
  final String? url;
  final String? fallbackUrl;

  bool get isBundled => url == null;

  @override
  List<Object?> get props => [id];
}

class ReaderPreferences extends Equatable {
  const ReaderPreferences({this.fontScale = 1.0, this.translationId});

  /// Multiplies the base Quran font size; 0.8…1.8.
  final double fontScale;

  /// Edition shown in the ayah sheet under the tafsir; null picks one for the UI
  /// language.
  final String? translationId;

  ReaderPreferences copyWith({
    double? fontScale,
    String? Function()? translationId,
  }) => ReaderPreferences(
    fontScale: fontScale ?? this.fontScale,
    translationId: translationId != null ? translationId() : this.translationId,
  );

  @override
  List<Object?> get props => [fontScale, translationId];
}
