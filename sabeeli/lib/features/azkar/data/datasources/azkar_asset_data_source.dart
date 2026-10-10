import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../quran/domain/entities/quran_entities.dart';
import '../../domain/entities/dhikr_step.dart';
import '../../domain/entities/azkar_entities.dart';

/// Hisn al-Muslim in Arabic, merged with its English translation by id.
@lazySingleton
class AzkarAssetDataSource {
  List<AzkarCategory>? _cache;
  List<DhikrStep>? _afterPrayer;

  /// The guided after-prayer sequence (built by tool/data/build_after_prayer.py).
  Future<List<DhikrStep>> afterPrayer() async {
    final cached = _afterPrayer;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/azkar/after_prayer.json');
    final steps = [
      for (final s
          in ((jsonDecode(raw) as Map<String, dynamic>)['steps']
                  as List<dynamic>)
              .cast<Map<String, dynamic>>())
        _step(s),
    ];
    return _afterPrayer = steps;
  }

  static DhikrStep _step(Map<String, dynamic> s) {
    final quran = (s['quran'] as List<dynamic>?)?.cast<int>();
    return DhikrStep(
      id: s['id'] as String,
      arabic: s['arabic'] as String?,
      quranFrom: quran == null ? null : AyahRef(quran[0], quran[1]),
      quranTo: quran == null ? null : AyahRef(quran[0], quran[2]),
      count: (s['count'] as num).toInt(),
      countAfterFajrAndMaghrib: (s['countFajrMaghrib'] as num?)?.toInt(),
      only: (s['only'] as List<dynamic>?)
          ?.map((p) => Prayer.values.byName(p as String))
          .toSet(),
      translation: s['translation'] as String?,
      transliteration: s['transliteration'] as String?,
      reference: s['reference'] as String?,
      virtue: s['virtue'] as String?,
    );
  }

  Future<List<AzkarCategory>> load() async {
    final cached = _cache;
    if (cached != null) return cached;
    final ar = await rootBundle.loadString('assets/azkar/azkar_ar.json');
    final en = await rootBundle.loadString('assets/azkar/azkar_en.json');
    final categories = await compute(_parse, (ar, en));
    _cache = categories;
    return categories;
  }

  static List<AzkarCategory> _parse((String, String) input) {
    List<Map<String, dynamic>> cats(String raw) =>
        ((jsonDecode(raw) as Map<String, dynamic>)['categories']
                as List<dynamic>)
            .cast<Map<String, dynamic>>();

    String? nonEmpty(Object? s) =>
        (s is String && s.trim().isNotEmpty) ? s.trim() : null;

    final english = {for (final c in cats(input.$2)) c['id'] as int: c};
    return [
      for (final c in cats(input.$1))
        () {
          final en = english[c['id']];
          final enItems = {
            for (final i
                in (en?['items'] as List<dynamic>? ?? const [])
                    .cast<Map<String, dynamic>>())
              i['id'] as int: i,
          };
          return AzkarCategory(
            id: c['id'] as int,
            key: c['key'] as String?,
            titleArabic: c['title'] as String,
            titleEnglish: en?['title'] as String? ?? c['title'] as String,
            items: [
              for (final i
                  in (c['items'] as List<dynamic>).cast<Map<String, dynamic>>())
                DhikrItem(
                  id: i['id'] as int,
                  arabic: i['text'] as String,
                  count: ((i['count'] as num?)?.toInt() ?? 1).clamp(1, 1000),
                  reference: nonEmpty(i['reference']),
                  virtue: nonEmpty(i['virtue']),
                  translation: nonEmpty(enItems[i['id']]?['text']),
                  transliteration: nonEmpty(
                    enItems[i['id']]?['transliteration'],
                  ),
                ),
            ],
          );
        }(),
    ];
  }
}
