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
  static const _readDaysKey = 'quran.readDays';
  static const _planKey = 'quran.plan';

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

  /// The days (local dates) on which the reader opened a page; the last 60.
  Set<DateTime> readDays() => {
    for (final d in _store.getJsonList(_readDaysKey) ?? const [])
      ?DateTime.tryParse(d as String),
  };

  Future<void> saveReadDays(Set<DateTime> days) {
    final sorted = days.toList()..sort();
    final kept = sorted.length > 60
        ? sorted.sublist(sorted.length - 60)
        : sorted;
    return _store.setJson(_readDaysKey, [
      for (final d in kept) d.toIso8601String().substring(0, 10),
    ]);
  }

  KhatmahPlan? plan() => KhatmahPlan.fromJson(_store.getJson(_planKey));

  Future<void> savePlan(KhatmahPlan? plan) => plan == null
      ? _store.remove(_planKey)
      : _store.setJson(_planKey, plan.toJson());

  ReaderPreferences preferences() {
    final j = _store.getJson(_prefsKey);
    if (j == null) return const ReaderPreferences();
    return ReaderPreferences(
      fontScale: ((j['scale'] as num?)?.toDouble() ?? 1.0).clamp(0.8, 1.8),
      translationId: j['translation'] as String?,
      riwayah: Riwayah.values.asNameMap()[j['riwayah']],
      theme: ReaderTheme.values.asNameMap()[j['theme']] ?? ReaderTheme.auto,
    );
  }

  Future<void> savePreferences(ReaderPreferences p) =>
      _store.setJson(_prefsKey, {
        'scale': p.fontScale,
        if (p.translationId != null) 'translation': p.translationId,
        if (p.riwayah != null) 'riwayah': p.riwayah!.name,
        'theme': p.theme.name,
      });
}
