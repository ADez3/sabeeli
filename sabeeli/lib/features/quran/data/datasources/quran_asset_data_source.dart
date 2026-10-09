import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/quran_entities.dart';

/// Reads the bundled mushaf, tafsir and translation (see assets/SOURCES.md).
@lazySingleton
class QuranAssetDataSource {
  QuranData? _data;
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

  Future<QuranData> load() async {
    final cached = _data;
    if (cached != null) return cached;
    final quran = await rootBundle.loadString('assets/quran/quran.json');
    final meta = await rootBundle.loadString('assets/quran/meta.json');
    // ~1.4 MB of JSON: parsed off the UI thread so opening the Quran never janks.
    final data = await compute(_parse, (quran, meta));
    _data = data;
    return data;
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

  static List<String> _parseList(String raw) =>
      (jsonDecode(raw) as List<dynamic>).cast<String>();

  static QuranData _parse((String, String) input) {
    final quran = jsonDecode(input.$1) as Map<String, dynamic>;
    final meta = jsonDecode(input.$2) as Map<String, dynamic>;

    AyahRef ref(dynamic j) {
      final m = j as Map<String, dynamic>;
      return AyahRef((m['s'] as num).toInt(), (m['a'] as num).toInt());
    }

    return QuranData(
      ayahs: [
        for (final s
            in (quran['surahs'] as List<dynamic>).cast<Map<String, dynamic>>())
          (s['ayahs'] as List<dynamic>).cast<String>(),
      ],
      surahs: [
        for (final s
            in (meta['surahs'] as List<dynamic>).cast<Map<String, dynamic>>())
          SurahInfo(
            number: (s['n'] as num).toInt(),
            nameArabic: s['ar'] as String,
            nameTransliterated: s['tr'] as String,
            nameEnglish: s['en'] as String,
            revelation: s['type'] == 'Medinan'
                ? Revelation.medinan
                : Revelation.meccan,
            ayahCount: (s['ayahs'] as num).toInt(),
            startPage: (s['page'] as num).toInt(),
          ),
      ],
      juzStarts: (meta['juz'] as List<dynamic>).map(ref).toList(),
      hizbQuarterStarts: (meta['hizbQuarters'] as List<dynamic>)
          .map(ref)
          .toList(),
      pageStarts: (meta['pages'] as List<dynamic>).map(ref).toList(),
      sajdas: [
        for (final s
            in (meta['sajdas'] as List<dynamic>).cast<Map<String, dynamic>>())
          SajdaInfo(ref(s), obligatory: s['type'] == 'obligatory'),
      ],
    );
  }
}
