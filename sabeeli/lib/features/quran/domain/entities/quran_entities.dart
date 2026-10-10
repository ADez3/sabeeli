import 'package:equatable/equatable.dart';

import 'riwayah.dart';

export 'riwayah.dart';

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
    required this.revelationOrder,
  });

  final int number;
  final String nameArabic;
  final String nameTransliterated;
  final String nameEnglish;
  final Revelation revelation;
  final int ayahCount;
  final int startPage;

  /// Position in the order of revelation (Al-Alaq is 1), as in the Tanzil data.
  final int revelationOrder;

  /// The English meaning, unless it only repeats the transliterated name (Ya-Sin is
  /// "Ya Sin").
  String? get meaningIfDistinct {
    String bare(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    return bare(nameEnglish) == bare(nameTransliterated) ? null : nameEnglish;
  }

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

/// The whole mushaf of one riwayah: text and structure, loaded once and kept in
/// memory (~2 MB).
///
/// Ayahs are numbered as in that riwayah's own mushaf (Warsh counts 6214, Hafs
/// 6236). Links, bookmarks, tafsir and translations use Hafs numbering, the
/// common reference; [toHafs] and [fromHafs] convert between the two.
class QuranData {
  QuranData({
    required this.ayahs,
    required this.surahs,
    required this.juzStarts,
    required this.hizbQuarterStarts,
    required this.pageStarts,
    required this.sajdas,
    this.riwayah = Riwayah.hafs,
    String? basmala,
    this.hafsMap,
    List<int>? hafsAyahCounts,
  }) : _offsets = _prefixSums(surahs.map((s) => s.ayahCount)),

       _hafsOffsets = hafsAyahCounts == null
           ? null
           : _prefixSums(hafsAyahCounts),
       basmala = basmala ?? ayahs.first.first {
    final map = hafsMap;
    if (map != null) {
      // For each Hafs ayah, the first ayah of this riwayah that contains it.
      final from = List<int>.filled(ayahTotal, -1);
      for (var i = map.length - 1; i >= 0; i--) {
        for (final h in map[i]) {
          from[h] = i;
        }
      }
      // Hafs ayahs this riwayah does not number (the basmala of al-Fatihah)
      // lead to the ayah that follows them.
      var next = map.length - 1;
      for (var h = ayahTotal - 1; h >= 0; h--) {
        if (from[h] == -1) {
          from[h] = next;
        } else {
          next = from[h];
        }
      }
      _fromHafs = from;
    }
  }

  final Riwayah riwayah;

  /// `ayahs[s - 1][a - 1]`, verbatim KFGQPC text without the end marker.
  final List<List<String>> ayahs;
  final List<SurahInfo> surahs;
  final List<AyahRef> juzStarts;

  /// Empty when the riwayah's data has no reliable hizb divisions.
  final List<AyahRef> hizbQuarterStarts;

  /// First ayah of each of the 604 pages of the Madani mushaf.
  final List<AyahRef> pageStarts;
  final List<SajdaInfo> sajdas;

  /// The basmala heading every surah but al-Fatihah and at-Tawbah, in this
  /// riwayah's own spelling (Hafs: ayah 1:1; Warsh and Qalun: cut from 27:30).
  final String basmala;

  final List<int> _offsets;

  /// For each ayah (flat index) the Hafs flat indices it covers; null for Hafs.
  final List<List<int>>? hafsMap;
  final List<int>? _hafsOffsets;
  List<int>? _fromHafs;

  static const pageCount = 604;

  /// Ayahs in Hafs numbering, the length of every tafsir and translation.
  static const ayahTotal = 6236;

  /// Ayahs in this riwayah.
  int get ayahCount => _offsets.last;

  /// Every surah but at-Tawbah opens with a basmala that is not one of its
  /// ayahs; in Hafs al-Fatihah is the exception, its basmala being ayah 1:1.
  bool hasBasmalaHeader(int surah) =>
      surah != 9 && (surah != 1 || riwayah != Riwayah.hafs);

  static List<int> _prefixSums(Iterable<int> counts) {
    final out = <int>[0];
    for (final c in counts) {
      out.add(out.last + c);
    }
    return out;
  }

  SurahInfo surah(int number) => surahs[number - 1];

  String text(AyahRef ref) => ayahs[ref.surah - 1][ref.ayah - 1];

  /// 0-based position of an ayah in the whole Quran (0…6235).
  int flatIndex(AyahRef ref) => _offsets[ref.surah - 1] + ref.ayah - 1;

  AyahRef fromFlatIndex(int index) => _refAt(_offsets, index);

  static AyahRef _refAt(List<int> offsets, int index) {
    var s = 0;
    while (offsets[s + 1] <= index) {
      s++;
    }
    return AyahRef(s + 1, index - offsets[s] + 1);
  }

  /// Hafs flat indices (0…6235) of the ayahs [ref] covers: what its tafsir and
  /// translation are made of.
  List<int> hafsIndicesOf(AyahRef ref) {
    final i = flatIndex(ref);
    return hafsMap?[i] ?? [i];
  }

  /// [ref] in Hafs numbering (its first Hafs ayah).
  AyahRef toHafs(AyahRef ref) {
    final offsets = _hafsOffsets;
    if (offsets == null) return ref;
    return _refAt(offsets, hafsIndicesOf(ref).first);
  }

  /// The ayah of this riwayah that holds the Hafs ayah [hafs].
  AyahRef fromHafs(AyahRef hafs) {
    final offsets = _hafsOffsets;
    final from = _fromHafs;
    if (offsets == null || from == null) return hafs;
    final s = hafs.surah.clamp(1, 114);
    final count = offsets[s] - offsets[s - 1];
    final h = offsets[s - 1] + hafs.ayah.clamp(1, count) - 1;
    return fromFlatIndex(from[h]);
  }

  /// The ayahs of this riwayah that together hold the Hafs ayahs [from]…[to]
  /// (Ayat al-Kursi, Hafs 2:255, is Warsh 2:253–254).
  List<AyahRef> fromHafsRange(AyahRef from, AyahRef to) {
    final a = flatIndex(fromHafs(from));
    var b = flatIndex(fromHafs(to));
    final map = hafsMap;
    final offsets = _hafsOffsets;
    if (map != null && offsets != null) {
      // Later ayahs may still carry part of the range's last Hafs ayah.
      final hafsLast = offsets[to.surah - 1] + to.ayah - 1;
      while (b + 1 < ayahCount && map[b + 1].contains(hafsLast)) {
        b++;
      }
    }
    return [for (var i = a; i <= b; i++) fromFlatIndex(i)];
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

  /// 1…240: each juz has two hizbs of four quarters; null when the riwayah's
  /// data has no hizb divisions.
  int? hizbQuarterOf(AyahRef ref) =>
      hizbQuarterStarts.isEmpty ? null : _sectionOf(hizbQuarterStarts, ref);

  /// Every ayah on a page, in order.
  List<AyahRef> ayahsOnPage(int page) {
    final start = flatIndex(pageStarts[page - 1]);
    final end = page < pageCount ? flatIndex(pageStarts[page]) : ayahCount;
    return [for (var i = start; i < end; i++) fromFlatIndex(i)];
  }

  /// First and last mushaf page of a surah (a page can hold the end of one surah
  /// and the start of the next).
  (int, int) surahPages(int surah) {
    final info = this.surah(surah);
    return (info.startPage, pageOf(AyahRef(surah, info.ayahCount)));
  }

  /// Share of a surah's pages the reader has opened, 0…1.
  double surahProgress(int surah, Set<int> readPages) {
    final (first, last) = surahPages(surah);
    var read = 0;
    for (var p = first; p <= last; p++) {
      if (readPages.contains(p)) read++;
    }
    return read / (last - first + 1);
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
  const ReaderPreferences({
    this.fontScale = 1.0,
    this.translationId,
    this.riwayah,
  });

  /// Multiplies the base Quran font size; 0.8…1.8.
  final double fontScale;

  /// Edition shown in the ayah sheet under the tafsir; null picks one for the UI
  /// language.
  final String? translationId;

  /// The riwayah chosen by the user; null follows the region.
  final Riwayah? riwayah;

  ReaderPreferences copyWith({
    double? fontScale,
    String? Function()? translationId,
    Riwayah? Function()? riwayah,
  }) => ReaderPreferences(
    fontScale: fontScale ?? this.fontScale,
    translationId: translationId != null ? translationId() : this.translationId,
    riwayah: riwayah != null ? riwayah() : this.riwayah,
  );

  @override
  List<Object?> get props => [fontScale, translationId, riwayah];
}
