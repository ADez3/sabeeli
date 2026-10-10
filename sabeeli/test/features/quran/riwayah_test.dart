import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/features/quran/data/datasources/quran_asset_data_source.dart';
import 'package:sabeeli/features/quran/domain/entities/quran_entities.dart';

QuranData _load(Riwayah riwayah) {
  String read(String path) => File(path).readAsStringSync();
  final dir = 'assets/quran/riwayat/${riwayah.assetDir}';
  return QuranAssetDataSource.parseRiwayah((
    riwayah,
    read('$dir/quran.json'),
    read('$dir/meta.json'),
    read('$dir/hafs_map.json'),
    read('assets/quran/meta.json'),
  ));
}

void main() {
  final warsh = _load(Riwayah.warsh);
  final qalun = _load(Riwayah.qalun);

  test('Warsh and Qalun are complete mushafs in Madani counting', () {
    for (final data in [warsh, qalun]) {
      expect(data.ayahCount, 6214);
      expect(data.surahs, hasLength(114));
      expect(data.pageStarts, hasLength(QuranData.pageCount));
      expect(data.juzStarts, hasLength(30));
      // Every page lists its ayahs, and all pages together cover them once.
      var total = 0;
      for (var p = 1; p <= QuranData.pageCount; p++) {
        final ayahs = data.ayahsOnPage(p);
        expect(ayahs, isNotEmpty, reason: 'page $p');
        total += ayahs.length;
      }
      expect(total, data.ayahCount);
    }
    expect(warsh.surah(2).ayahCount, 285);
    expect(warsh.sajdas, hasLength(14));
    expect(warsh.hizbQuarterOf(const AyahRef(2, 1)), isNull);
  });

  test('the basmala is not an ayah, and heads surahs in its own spelling', () {
    expect(warsh.basmala, startsWith('بِسْمِ'));
    expect(warsh.text(const AyahRef(1, 1)), startsWith('اِ۬لْحَمْدُ'));
    expect(warsh.text(const AyahRef(27, 30)), contains(warsh.basmala));
  });

  test('ayahs map to and from Hafs numbering', () {
    // Al-Fatihah: Warsh 1:1 is Hafs 1:2; the Hafs basmala leads to Warsh 1:1.
    expect(warsh.toHafs(const AyahRef(1, 1)), const AyahRef(1, 2));
    expect(warsh.fromHafs(const AyahRef(1, 1)), const AyahRef(1, 1));
    // Warsh 2:1 holds Hafs 2:1 and 2:2.
    expect(warsh.hafsIndicesOf(const AyahRef(2, 1)), [7, 8]);
    expect(warsh.fromHafs(const AyahRef(2, 2)), const AyahRef(2, 1));
    // Ayat al-Kursi, Hafs 2:255, is two ayahs in Warsh.
    expect(
      warsh.fromHafsRange(const AyahRef(2, 255), const AyahRef(2, 255)),
      const [AyahRef(2, 253), AyahRef(2, 254)],
    );
    // The three Quls are numbered alike.
    expect(
      warsh.fromHafsRange(const AyahRef(112, 1), const AyahRef(112, 4)),
      [for (var a = 1; a <= 4; a++) AyahRef(112, a)],
    );
    // Round trip through Hafs: back to the same ayah, or (where a Hafs ayah is
    // shared by two Warsh ayahs) to the earlier one that also holds it.
    var exact = 0;
    for (var i = 0; i < warsh.ayahCount; i++) {
      final ref = warsh.fromFlatIndex(i);
      final back = warsh.fromHafs(warsh.toHafs(ref));
      if (back == ref) exact++;
      expect(back <= ref, isTrue, reason: '$ref');
      expect(
        warsh.hafsIndicesOf(back),
        contains(warsh.hafsIndicesOf(ref).first),
        reason: '$ref',
      );
    }
    expect(exact, greaterThan(6150));
  });

  test('the riwayah follows the region until chosen', () {
    expect(Riwayah.forCountry('MA'), Riwayah.warsh);
    expect(Riwayah.forCountry('dz'), Riwayah.warsh);
    expect(Riwayah.forCountry('LY'), Riwayah.qalun);
    expect(Riwayah.forCountry('SA'), Riwayah.hafs);
    expect(Riwayah.forCountry(null), Riwayah.hafs);
  });
}
