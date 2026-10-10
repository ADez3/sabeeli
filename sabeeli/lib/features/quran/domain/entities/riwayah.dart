/// A transmission (riwayah) of the Quran's recitation, each written in its own
/// mushaf. All are from the King Fahd Complex (see assets/SOURCES.md).
enum Riwayah {
  /// Hafs 'an 'Asim: most of the Muslim world.
  hafs(fontFamily: 'UthmanicHafs', assetDir: null),

  /// Warsh 'an Nafi': the Maghreb and much of West Africa.
  warsh(fontFamily: 'UthmanicWarsh', assetDir: 'warsh'),

  /// Qalun 'an Nafi': Libya, and parts of Tunisia.
  qalun(fontFamily: 'UthmanicQaloun', assetDir: 'qalun');

  const Riwayah({required this.fontFamily, required this.assetDir});

  /// The font the text of this riwayah is encoded for; never mixed.
  final String fontFamily;

  /// Folder under assets/quran/riwayat; null for Hafs, the base text.
  final String? assetDir;

  /// The riwayah read where [countryCode] is, used until the user picks one.
  static Riwayah forCountry(String? countryCode) =>
      switch (countryCode?.toUpperCase()) {
        'MA' || 'DZ' || 'MR' || 'EH' => warsh,
        'SN' || 'ML' || 'NE' || 'GM' || 'GN' => warsh,
        'LY' || 'TN' => qalun,
        _ => hafs,
      };
}
