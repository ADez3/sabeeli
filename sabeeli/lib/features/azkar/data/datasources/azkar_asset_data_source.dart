import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/azkar_entities.dart';

/// Hisn al-Muslim in Arabic, merged with its English translation by id.
@lazySingleton
class AzkarAssetDataSource {
  List<AzkarCategory>? _cache;

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
