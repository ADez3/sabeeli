import 'package:equatable/equatable.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';

/// How a prayer announces itself.
enum PrayerAlert {
  /// A notification with the phone's notification sound.
  sound,

  /// A notification without sound.
  silent,

  /// Nothing.
  off,
}

class PrayerSettings extends Equatable {
  const PrayerSettings({
    this.calculation = const CalculationParameters(),
    this.alerts = defaultAlerts,
    this.reminderMinutes = 0,
    this.methodChosenByUser = false,
  });

  static const defaultAlerts = {
    Prayer.fajr: PrayerAlert.sound,
    Prayer.sunrise: PrayerAlert.off,
    Prayer.dhuhr: PrayerAlert.sound,
    Prayer.asr: PrayerAlert.sound,
    Prayer.maghrib: PrayerAlert.sound,
    Prayer.isha: PrayerAlert.sound,
  };

  final CalculationParameters calculation;
  final Map<Prayer, PrayerAlert> alerts;

  /// Minutes before each prayer for a quiet reminder; 0 disables reminders.
  final int reminderMinutes;

  /// Until the user picks a method, it follows the country of the location.
  final bool methodChosenByUser;

  PrayerAlert alertFor(Prayer prayer) => alerts[prayer] ?? PrayerAlert.off;

  PrayerSettings copyWith({
    CalculationParameters? calculation,
    Map<Prayer, PrayerAlert>? alerts,
    int? reminderMinutes,
    bool? methodChosenByUser,
  }) => PrayerSettings(
    calculation: calculation ?? this.calculation,
    alerts: alerts ?? this.alerts,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    methodChosenByUser: methodChosenByUser ?? this.methodChosenByUser,
  );

  @override
  List<Object?> get props => [
    calculation,
    alerts,
    reminderMinutes,
    methodChosenByUser,
  ];
}
