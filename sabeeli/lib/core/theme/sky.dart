import 'package:flutter/painting.dart';

import '../astronomy/prayer.dart';
import '../astronomy/prayer_calculator.dart';

/// The part of the day between two prayer times. The hero card takes the colour
/// of the real sky for the current one.
enum SkyPhase {
  night([Color(0xFF0B1030), Color(0xFF161A45), Color(0xFF241F52)], stars: true),
  dawn([Color(0xFF1D2556), Color(0xFF5A4A8A), Color(0xFFC9817A)], stars: true),
  morning([Color(0xFF1A4594), Color(0xFF346DC2), Color(0xFF5F95D6)]),
  midday([Color(0xFF1B4F9C), Color(0xFF3778C6), Color(0xFF6FA6DE)]),
  golden([Color(0xFF283672), Color(0xFF8A5660), Color(0xFFD9955A)]),
  dusk([Color(0xFF17143A), Color(0xFF52295C), Color(0xFFB04E48)], stars: true);

  const SkyPhase(this.colors, {this.stars = false});

  /// Top to bottom.
  final List<Color> colors;

  /// Whether stars are visible in this part of the day.
  final bool stars;

  static SkyPhase at(PrayerTimes today, DateTime now) =>
      switch (today.currentAt(now)) {
        null => night,
        Prayer.fajr => dawn,
        Prayer.sunrise => morning,
        Prayer.dhuhr => midday,
        Prayer.asr => golden,
        Prayer.maghrib => dusk,
        Prayer.isha => night,
      };
}
