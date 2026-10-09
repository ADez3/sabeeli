import '../../../../core/astronomy/calculation_method.dart';
import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../domain/entities/prayer_settings.dart';

/// Stored by enum name, so reordering an enum never corrupts saved settings, and an
/// unknown name (from a newer version) falls back to the default.
abstract final class PrayerSettingsModel {
  static PrayerSettings fromJson(Map<String, dynamic> json) {
    const defaults = PrayerSettings();
    final prayers = Prayer.values.asNameMap();
    return PrayerSettings(
      calculation: CalculationParameters(
        method:
            CalculationMethod.values.asNameMap()[json['method']] ??
            defaults.calculation.method,
        madhab:
            AsrMadhab.values.asNameMap()[json['madhab']] ??
            defaults.calculation.madhab,
        highLatitudeRule:
            HighLatitudeRule.values.asNameMap()[json['highLat']] ??
            defaults.calculation.highLatitudeRule,
        userAdjustments: {
          for (final e
              in (json['adjust'] as Map<String, dynamic>? ?? const {}).entries)
            if (prayers[e.key] != null)
              prayers[e.key]!: (e.value as num).toInt(),
        },
      ),
      alerts: {
        ...PrayerSettings.defaultAlerts,
        for (final e
            in (json['alerts'] as Map<String, dynamic>? ?? const {}).entries)
          if (prayers[e.key] != null && _alert(e.value) != null)
            prayers[e.key]!: _alert(e.value)!,
      },
      reminderMinutes: (json['reminder'] as num?)?.toInt() ?? 0,
      methodChosenByUser: json['methodChosen'] as bool? ?? false,
    );
  }

  /// "adhan" was an option in early builds; it now means the phone's sound.
  static PrayerAlert? _alert(Object? name) => name == 'adhan'
      ? PrayerAlert.sound
      : PrayerAlert.values.asNameMap()[name];

  static Map<String, dynamic> toJson(PrayerSettings s) => {
    'method': s.calculation.method.name,
    'madhab': s.calculation.madhab.name,
    'highLat': s.calculation.highLatitudeRule.name,
    'adjust': {
      for (final e in s.calculation.userAdjustments.entries)
        e.key.name: e.value,
    },
    'alerts': {for (final e in s.alerts.entries) e.key.name: e.value.name},
    'reminder': s.reminderMinutes,
    'methodChosen': s.methodChosenByUser,
  };
}
