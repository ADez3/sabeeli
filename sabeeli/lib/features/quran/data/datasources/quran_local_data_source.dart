import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/quran_entities.dart';

/// Bookmarks, reading position and reader preferences.
@lazySingleton
class QuranLocalDataSource {
  const QuranLocalDataSource(this._store);
  final KeyValueStore _store;

  static const _bookmarksKey = 'quran.bookmarks';
  static const _positionKey = 'quran.position';
  static const _prefsKey = 'quran.prefs';
  static const _readPagesKey = 'quran.readPages';

  List<Bookmark> bookmarks() => [
    for (final j
        in (_store.getJsonList(_bookmarksKey) ?? const [])
            .cast<Map<String, dynamic>>())
      Bookmark(
        ref: AyahRef((j['s'] as num).toInt(), (j['a'] as num).toInt()),
        createdAt: DateTime.fromMillisecondsSinceEpoch((j['t'] as num).toInt()),
      ),
  ];

  Future<void> saveBookmarks(List<Bookmark> bookmarks) =>
      _store.setJson(_bookmarksKey, [
        for (final b in bookmarks)
          {
            's': b.ref.surah,
            'a': b.ref.ayah,
            't': b.createdAt.millisecondsSinceEpoch,
          },
      ]);

  ReadingPosition? position() {
    final j = _store.getJson(_positionKey);
    if (j == null) return null;
    return ReadingPosition(
      ref: AyahRef((j['s'] as num).toInt(), (j['a'] as num).toInt()),
      page: (j['p'] as num).toInt(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch((j['t'] as num).toInt()),
    );
  }

  Future<void> savePosition(ReadingPosition p) => _store.setJson(_positionKey, {
    's': p.ref.surah,
    'a': p.ref.ayah,
    'p': p.page,
    't': p.updatedAt.millisecondsSinceEpoch,
  });

  /// Pages the reader has settled on at least once: the light of the Quran sky.
  Set<int> readPages() => {
    for (final p in _store.getJsonList(_readPagesKey) ?? const [])
      (p as num).toInt(),
  };

  Future<void> saveReadPages(Set<int> pages) =>
      _store.setJson(_readPagesKey, pages.toList()..sort());

  ReaderPreferences preferences() {
    final j = _store.getJson(_prefsKey);
    if (j == null) return const ReaderPreferences();
    return ReaderPreferences(
      fontScale: ((j['scale'] as num?)?.toDouble() ?? 1.0).clamp(0.8, 1.8),
      translationId: j['translation'] as String?,
      riwayah: Riwayah.values.asNameMap()[j['riwayah']],
    );
  }

  Future<void> savePreferences(ReaderPreferences p) =>
      _store.setJson(_prefsKey, {
        'scale': p.fontScale,
        if (p.translationId != null) 'translation': p.translationId,
        if (p.riwayah != null) 'riwayah': p.riwayah!.name,
      });
}
