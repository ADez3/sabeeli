import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../domain/entities/azkar_entities.dart';

/// The categories given a tile of their own, in display order.
const featuredAzkar = ['morning', 'evening', 'after_prayer', 'sleep', 'waking'];

extension AzkarLabels on BuildContext {
  String azkarTitle(AzkarCategory c) {
    final l10n = this.l10n;
    return switch (c.key) {
      'morning' => l10n.azkarMorning,
      'evening' => l10n.azkarEvening,
      'after_prayer' => l10n.azkarAfterPrayer,
      'sleep' => l10n.azkarSleep,
      'waking' => l10n.azkarWaking,
      _ => languageCode == 'ar' ? c.titleArabic : c.titleEnglish,
    };
  }
}

IconData azkarIcon(String? key) => switch (key) {
  'morning' => Icons.wb_sunny_rounded,
  'evening' => Icons.nights_stay_rounded,
  'after_prayer' => Icons.mosque_rounded,
  'sleep' => Icons.bedtime_rounded,
  'waking' => Icons.alarm_on_rounded,
  'travel' ||
  'riding' ||
  'returning_from_travel' => Icons.flight_takeoff_rounded,
  'food' || 'after_eating' || 'breaking_fast' => Icons.restaurant_rounded,
  'entering_home' || 'leaving_home' => Icons.home_rounded,
  'mosque_entering' ||
  'mosque_leaving' ||
  'going_to_mosque' => Icons.mosque_outlined,
  'wudu' || 'wudu_after' => Icons.water_drop_outlined,
  'distress' || 'worry_grief' || 'calamity' || 'anger' => Icons.healing_rounded,
  'rain' || 'rain_seeking' || 'thunder' || 'wind' => Icons.cloud_outlined,
  'istighfar' || 'after_sin' => Icons.favorite_border_rounded,
  _ => Icons.auto_awesome_outlined,
};

/// The tile to suggest on the home screen at [now]: morning azkar from Fajr until
/// mid-morning, evening azkar from Asr until night.
String? suggestedAzkarKey(DateTime now) {
  final h = now.hour;
  if (h >= 4 && h < 11) return 'morning';
  if (h >= 15 && h < 21) return 'evening';
  if (h >= 21 || h < 4) return 'sleep';
  return null;
}
