import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_json.dart';
import '../../domain/entities/quran_entities.dart';

/// Downloads translations on demand (fawazahmed0/quran-api on jsDelivr) and caches
/// them on disk, so each one is fetched once and then works offline.
@lazySingleton
class TranslationRemoteDataSource {
  TranslationRemoteDataSource(this._http);

  final HttpJson _http;
  final Map<String, List<String>> _memory = {};

  Future<File> _file(String id) async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/translations/$id.json');
  }

  Future<bool> isDownloaded(String id) async =>
      _memory.containsKey(id) || await (await _file(id)).exists();

  Future<List<String>?> cached(String id) async {
    final hit = _memory[id];
    if (hit != null) return hit;
    final file = await _file(id);
    if (!await file.exists()) return null;
    final list = await compute(_decodeList, await file.readAsString());
    return _memory[id] = list;
  }

  Future<List<String>> download(QuranEdition edition) async {
    final urls = [?edition.url, ?edition.fallbackUrl];
    Object? lastError;
    for (final url in urls) {
      try {
        final json = await _http.get(Uri.parse(url)) as Map<String, dynamic>;
        final verses = (json['quran'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        final list = [for (final v in verses) v['text'] as String? ?? ''];
        if (list.length != QuranData.ayahTotal) {
          throw NetworkException('${edition.id}: ${list.length} verses');
        }
        final file = await _file(edition.id);
        await file.parent.create(recursive: true);
        await file.writeAsString(jsonEncode(list));
        return _memory[edition.id] = list;
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? const NetworkException('No URL');
  }

  static List<String> _decodeList(String raw) =>
      (jsonDecode(raw) as List<dynamic>).cast<String>();
}
