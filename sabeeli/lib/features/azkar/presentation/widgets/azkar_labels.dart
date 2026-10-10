import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../l10n/l10n.dart';
import '../../domain/entities/azkar_entities.dart';

/// The categories given a tile of their own, in display order.
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
  'morning' => LucideIcons.sun,
  'evening' => LucideIcons.moonStar,
  'after_prayer' => LucideIcons.landmark,
  'sleep' => LucideIcons.bed,
  'waking' => LucideIcons.alarmClockCheck,
  'travel' || 'riding' || 'returning_from_travel' => LucideIcons.plane,
  'food' || 'after_eating' || 'breaking_fast' => LucideIcons.utensils,
  'entering_home' || 'leaving_home' => LucideIcons.house,
  'mosque_entering' ||
  'mosque_leaving' ||
  'going_to_mosque' => LucideIcons.landmark,
  'wudu' || 'wudu_after' => LucideIcons.droplet,
  'distress' ||
  'worry_grief' ||
  'calamity' ||
  'anger' => LucideIcons.heartHandshake,
  'rain' || 'rain_seeking' || 'thunder' || 'wind' => LucideIcons.cloud,
  'istighfar' || 'after_sin' => LucideIcons.heart,
  _ => LucideIcons.handHeart,
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
