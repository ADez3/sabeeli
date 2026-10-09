import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/features/quran/domain/entities/quran_entities.dart';

/// Builds [QuranData] from the real bundled assets, so a broken data rebuild is caught.
QuranData loadQuran() {
  final quran = jsonDecode(
    File('assets/quran/quran.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final meta = jsonDecode(
    File('assets/quran/meta.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  AyahRef ref(dynamic j) => AyahRef(j['s'] as int, j['a'] as int);
  return QuranData(
    ayahs: [
      for (final s in quran['surahs'] as List)
        (s['ayahs'] as List).cast<String>(),
    ],
    surahs: [
      for (final s in meta['surahs'] as List)
        SurahInfo(
          number: s['n'] as int,
          nameArabic: s['ar'] as String,
          nameTransliterated: s['tr'] as String,
          nameEnglish: s['en'] as String,
          revelation: s['type'] == 'Medinan'
              ? Revelation.medinan
              : Revelation.meccan,
          ayahCount: s['ayahs'] as int,
          startPage: s['page'] as int,
        ),
    ],
    juzStarts: (meta['juz'] as List).map(ref).toList(),
    hizbQuarterStarts: (meta['hizbQuarters'] as List).map(ref).toList(),
    pageStarts: (meta['pages'] as List).map(ref).toList(),
    sajdas: const [],
  );
}

void main() {
  final data = loadQuran();

  test('structure counts', () {
    expect(data.surahs, hasLength(114));
    expect(
      data.ayahs.fold<int>(0, (n, s) => n + s.length),
      QuranData.ayahTotal,
    );
    expect(data.pageStarts, hasLength(QuranData.pageCount));
    expect(data.juzStarts, hasLength(30));
    expect(data.hizbQuarterStarts, hasLength(240));
  });

  test(
    'every page lists its ayahs, and all pages together cover the Quran once',
    () {
      var total = 0;
      for (var p = 1; p <= QuranData.pageCount; p++) {
        final ayahs = data.ayahsOnPage(p);
        expect(ayahs, isNotEmpty, reason: 'page $p');
        for (final a in ayahs) {
          expect(data.pageOf(a), p);
        }
        total += ayahs.length;
      }
      expect(total, QuranData.ayahTotal);
    },
  );

  test('well-known positions', () {
    expect(data.pageOf(const AyahRef(1, 1)), 1);
    expect(data.pageOf(const AyahRef(2, 1)), 2);
    expect(data.pageOf(const AyahRef(2, 255)), 42);
    expect(data.pageOf(const AyahRef(114, 6)), 604);
    expect(data.juzOf(const AyahRef(2, 142)), 2);
    expect(data.juzOf(const AyahRef(78, 1)), 30);
    for (final s in data.surahs) {
      expect(
        data.pageOf(AyahRef(s.number, 1)),
        s.startPage,
        reason: 'surah ${s.number}',
      );
    }
  });

  test('flat index round-trips', () {
    for (var i = 0; i < QuranData.ayahTotal; i += 37) {
      expect(data.flatIndex(data.fromFlatIndex(i)), i);
    }
    expect(data.fromFlatIndex(QuranData.ayahTotal - 1), const AyahRef(114, 6));
  });

  test('the basmala is not repeated inside the first ayah of a surah', () {
    final basmala = data.text(const AyahRef(1, 1));
    for (final s in data.surahs.where((s) => s.hasBasmalaHeader)) {
      expect(
        data.text(AyahRef(s.number, 1)).startsWith(basmala),
        isFalse,
        reason: 'surah ${s.number}',
      );
    }
  });
}
