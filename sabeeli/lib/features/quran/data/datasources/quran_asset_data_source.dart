import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/quran_entities.dart';

/// Reads the bundled mushafs, tafsir and translation (see assets/SOURCES.md).
@lazySingleton
class QuranAssetDataSource {
  final Map<Riwayah, QuranData> _data = {};
  final Map<String, List<String>> _editions = {};

  static const tafsirMuyassarId = 'ar_muyassar';
  static const englishSahihId = 'en_sahih';

  static const bundledEditions = [
    QuranEdition(
      id: tafsirMuyassarId,
      languageCode: 'ar',
      name: 'التفسير الميسر',
      isTafsir: true,
      isRtl: true,
    ),
    QuranEdition(
      id: englishSahihId,
      languageCode: 'en',
      name: 'Saheeh International',
      isTafsir: false,
      isRtl: false,
    ),
  ];

  Future<QuranData> load(Riwayah riwayah) async {
    final cached = _data[riwayah];
    if (cached != null) return cached;
    // The Hafs metadata also names the surahs of the other riwayat.
    final meta = await rootBundle.loadString('assets/quran/meta.json');
    final dir = riwayah.assetDir;
    // ~1.4 MB of JSON: parsed off the UI thread so opening the Quran never janks.
    final data = dir == null
        ? await compute(parseHafs, (
            await rootBundle.loadString('assets/quran/quran.json'),
            meta,
          ))
        : await compute(parseRiwayah, (
            riwayah,
            await rootBundle.loadString('assets/quran/riwayat/$dir/quran.json'),
            await rootBundle.loadString('assets/quran/riwayat/$dir/meta.json'),
            await rootBundle.loadString(
              'assets/quran/riwayat/$dir/hafs_map.json',
            ),
            meta,
          ));
    return _data[riwayah] = data;
  }

  /// A bundled edition as a flat list of 6236 strings in mushaf order.
  Future<List<String>> bundledEdition(String id) async {
    final cached = _editions[id];
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/quran/tafsir/$id.json');
    final list = await compute(_parseList, raw);
    return _editions[id] = list;
  }

  Future<List<QuranEdition>> catalog() async {
    final raw = await rootBundle.loadString(
      'assets/quran/translations_catalog.json',
    );
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final e in list.cast<Map<String, dynamic>>())
        QuranEdition(
          id: e['id'] as String,
          languageCode: e['lang'] as String,
          name: e['name'] as String,
          isTafsir: e['kind'] == 'tafsir',
          isRtl: e['dir'] == 'rtl',
          url: e['url'] as String,
          fallbackUrl: e['fallbackUrl'] as String?,
        ),
    ];
  }

  static AyahRef _ref(dynamic j) {
    final m = j as Map<String, dynamic>;
    return AyahRef((m['s'] as num).toInt(), (m['a'] as num).toInt());
  }

  static List<List<String>> _ayahs(Map<String, dynamic> quran) => [
    for (final s
        in (quran['surahs'] as List<dynamic>).cast<Map<String, dynamic>>())
      (s['ayahs'] as List<dynamic>).cast<String>(),
  ];

  static List<SurahInfo> _surahs(
    Map<String, dynamic> hafsMeta, [
    Map<String, dynamic>? riwayahMeta,
  ]) {
    final own = (riwayahMeta?['surahs'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>();
    return [
      for (final (i, s)
          in (hafsMeta['surahs'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .indexed)
        SurahInfo(
          number: (s['n'] as num).toInt(),
          nameArabic: s['ar'] as String,
          nameTransliterated: s['tr'] as String,
          nameEnglish: s['en'] as String,
          revelation: s['type'] == 'Medinan'
              ? Revelation.medinan
              : Revelation.meccan,
          // Counts and pages differ between riwayat; names do not.
          ayahCount: ((own?[i] ?? s)['ayahs'] as num).toInt(),
          startPage: ((own?[i] ?? s)['page'] as num).toInt(),
          revelationOrder: (s['order'] as num).toInt(),
        ),
    ];
  }

  static List<SajdaInfo> _sajdas(Map<String, dynamic> meta) => [
    for (final s
        in (meta['sajdas'] as List<dynamic>).cast<Map<String, dynamic>>())
      SajdaInfo(_ref(s), obligatory: s['type'] == 'obligatory'),
  ];

  @visibleForTesting
  static QuranData parseRiwayah(
    (Riwayah, String, String, String, String) input,
  ) {
    final (riwayah, quranRaw, metaRaw, mapRaw, hafsMetaRaw) = input;
    final meta = jsonDecode(metaRaw) as Map<String, dynamic>;
    final hafsMeta = jsonDecode(hafsMetaRaw) as Map<String, dynamic>;
    return QuranData(
      riwayah: riwayah,
      ayahs: _ayahs(jsonDecode(quranRaw) as Map<String, dynamic>),
      surahs: _surahs(hafsMeta, meta),
      juzStarts: (meta['juz'] as List<dynamic>).map(_ref).toList(),
      hizbQuarterStarts: (meta['hizbQuarters'] as List<dynamic>)
          .map(_ref)
          .toList(),
      pageStarts: (meta['pages'] as List<dynamic>).map(_ref).toList(),
      sajdas: _sajdas(meta),
      basmala: meta['basmala'] as String,
      hafsMap: [
        for (final l
            in ((jsonDecode(mapRaw) as Map<String, dynamic>)['toHafs']
                as List<dynamic>))
          (l as List<dynamic>).cast<int>(),
      ],
      hafsAyahCounts: [
        for (final s
            in (hafsMeta['surahs'] as List<dynamic>)
                .cast<Map<String, dynamic>>())
          (s['ayahs'] as num).toInt(),
      ],
    );
  }

  static List<String> _parseList(String raw) =>
      (jsonDecode(raw) as List<dynamic>).cast<String>();

  @visibleForTesting
  static QuranData parseHafs((String, String) input) {
    final quran = jsonDecode(input.$1) as Map<String, dynamic>;
    final meta = jsonDecode(input.$2) as Map<String, dynamic>;
    return QuranData(
      ayahs: _ayahs(quran),
      surahs: _surahs(meta),
      juzStarts: (meta['juz'] as List<dynamic>).map(_ref).toList(),
      hizbQuarterStarts: (meta['hizbQuarters'] as List<dynamic>)
          .map(_ref)
          .toList(),
      pageStarts: (meta['pages'] as List<dynamic>).map(_ref).toList(),
      sajdas: _sajdas(meta),
    );
  }
}
