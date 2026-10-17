import 'prayer.dart';

/// How the Asr shadow length is measured.
enum AsrMadhab {
  /// Shafi'i, Maliki, Hanbali and Ja'fari: shadow equals the object's length.
  standard(1),

  /// Hanafi: shadow is twice the object's length.
  hanafi(2);

  const AsrMadhab(this.shadowFactor);
  final int shadowFactor;
}

/// What to do where the sun never descends far enough below the horizon for the Fajr
/// or Isha angle (summer above roughly 48° latitude): the formula then has no answer,
/// so these rules derive the time from a portion of the night instead.
enum HighLatitudeRule {
  /// Fajr and Isha never cross the middle of the night.
  middleOfTheNight,

  /// Fajr no earlier than the last seventh of the night, Isha no later than the first.
  seventhOfTheNight,

  /// The portion of the night is angle / 60 (for 18° that is 18/60 of the night).
  twilightAngle,

  /// Use the angles as-is, and leave a time unset when it cannot be computed.
  none,
}

/// The published parameters of a prayer-time authority.
///
/// Angles are degrees below the horizon. When [ishaMinutes] is set, Isha is that many
/// minutes after Maghrib instead of an angle (Umm al-Qura, Qatar). [adjustments] are
/// the per-prayer minute offsets some authorities publish (Diyanet, Dubai, Singapore).
enum CalculationMethod {
  muslimWorldLeague(fajrAngle: 18, ishaAngle: 17),
  egyptian(fajrAngle: 19.5, ishaAngle: 17.5),
  karachi(fajrAngle: 18, ishaAngle: 18),
  ummAlQura(fajrAngle: 18.5, ishaMinutes: 90),
  dubai(
    fajrAngle: 18.2,
    ishaAngle: 18.2,
    adjustments: {
      Prayer.sunrise: -3,
      Prayer.dhuhr: 3,
      Prayer.asr: 3,
      Prayer.maghrib: 3,
    },
  ),
  qatar(fajrAngle: 18, ishaMinutes: 90),
  kuwait(fajrAngle: 18, ishaAngle: 17.5),
  northAmerica(fajrAngle: 15, ishaAngle: 15),
  singapore(fajrAngle: 20, ishaAngle: 18, adjustments: {Prayer.dhuhr: 1}),
  turkey(
    fajrAngle: 18,
    ishaAngle: 17,
    adjustments: {
      Prayer.sunrise: -7,
      Prayer.dhuhr: 5,
      Prayer.asr: 4,
      Prayer.maghrib: 7,
    },
  ),
  tehran(
    fajrAngle: 17.7,
    ishaAngle: 14,
    maghribAngle: 4.5,
    jafariMidnight: true,
  ),
  france(fajrAngle: 12, ishaAngle: 12),
  russia(fajrAngle: 16, ishaAngle: 15),
  // The Ministry of Habous tables: checked against a month of Casablanca times,
  // these offsets give the same minute for 181 of 186 times (the rest by one).
  morocco(
    fajrAngle: 19,
    ishaAngle: 17,
    adjustments: {Prayer.sunrise: -3, Prayer.dhuhr: 5, Prayer.maghrib: 5},
  ),
  algeria(fajrAngle: 18, ishaAngle: 17, adjustments: {Prayer.maghrib: 3}),
  tunisia(fajrAngle: 18, ishaAngle: 18),
  jordan(fajrAngle: 18, ishaAngle: 18, adjustments: {Prayer.maghrib: 5}),
  indonesia(fajrAngle: 20, ishaAngle: 18),
  malaysia(fajrAngle: 18, ishaAngle: 18);

  const CalculationMethod({
    required this.fajrAngle,
    this.ishaAngle,
    this.ishaMinutes,
    this.maghribAngle,
    this.jafariMidnight = false,
    this.adjustments = const {},
  });

  final double fajrAngle;
  final double? ishaAngle;
  final int? ishaMinutes;
  final double? maghribAngle;

  /// Ja'fari midnight is halfway between sunset and Fajr rather than sunrise.
  final bool jafariMidnight;
  final Map<Prayer, int> adjustments;

  /// The authority most mosques follow in a country, by ISO 3166-1 alpha-2 code.
  ///
  /// Used once, when the first location fix arrives; the user can change it after.
  static CalculationMethod forCountry(String? countryCode) =>
      switch (countryCode?.toUpperCase()) {
        'SA' || 'YE' => ummAlQura,
        'AE' => dubai,
        'QA' || 'BH' || 'OM' => qatar,
        'KW' => kuwait,
        'EG' || 'SD' || 'LY' || 'SY' || 'LB' || 'IQ' || 'PS' => egyptian,
        'JO' => jordan,
        'PK' || 'IN' || 'BD' || 'AF' => karachi,
        'IR' => tehran,
        'TR' || 'AZ' => turkey,
        'MA' => morocco,
        'DZ' => algeria,
        'TN' => tunisia,
        'US' || 'CA' => northAmerica,
        'FR' || 'BE' => france,
        'RU' || 'KZ' || 'UZ' || 'TJ' || 'KG' || 'TM' => russia,
        'SG' || 'BN' => singapore,
        'MY' => malaysia,
        'ID' => indonesia,
        _ => muslimWorldLeague,
      };
}
