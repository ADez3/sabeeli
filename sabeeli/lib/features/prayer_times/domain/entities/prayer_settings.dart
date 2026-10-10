import 'package:equatable/equatable.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/hijri/fasting.dart';

export '../../../../core/hijri/fasting.dart' show FastKind;

/// How a prayer announces itself.
enum PrayerAlert {
  /// A notification with the phone's notification sound.
  sound,

  /// A notification without sound.
  silent,

  /// Nothing.
  off,
}

/// Optional daily reminders, each at a time the user picks. All are off until
/// chosen: the same notification every day soon turns into noise, so they are
/// for those they actually help.
enum DailyReminder { morningAzkar, eveningAzkar, sleepAzkar, quran }

class PrayerSettings extends Equatable {
  const PrayerSettings({
    this.calculation = const CalculationParameters(),
    this.alerts = defaultAlerts,
    this.reminderMinutes = 0,
    this.methodChosenByUser = false,
    this.dailyReminders = const {},
    this.fastReminderMinutes,
    this.fastKinds = Fasting.voluntary,
    this.suhoorMinutes,
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

  /// The daily reminders turned on, at minutes after local midnight.
  final Map<DailyReminder, int> dailyReminders;

  /// The evening before a voluntary fast, at minutes after midnight; null off.
  final int? fastReminderMinutes;

  /// Which voluntary fasts that reminder is for.
  final Set<FastKind> fastKinds;

  /// In Ramadan, a reminder this many minutes before Fajr; null off.
  final int? suhoorMinutes;

  PrayerAlert alertFor(Prayer prayer) => alerts[prayer] ?? PrayerAlert.off;

  PrayerSettings copyWith({
    CalculationParameters? calculation,
    Map<Prayer, PrayerAlert>? alerts,
    int? reminderMinutes,
    bool? methodChosenByUser,
    Map<DailyReminder, int>? dailyReminders,
    int? Function()? fastReminderMinutes,
    Set<FastKind>? fastKinds,
    int? Function()? suhoorMinutes,
  }) => PrayerSettings(
    calculation: calculation ?? this.calculation,
    alerts: alerts ?? this.alerts,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    methodChosenByUser: methodChosenByUser ?? this.methodChosenByUser,
    dailyReminders: dailyReminders ?? this.dailyReminders,
    fastReminderMinutes: fastReminderMinutes != null
        ? fastReminderMinutes()
        : this.fastReminderMinutes,
    fastKinds: fastKinds ?? this.fastKinds,
    suhoorMinutes: suhoorMinutes != null ? suhoorMinutes() : this.suhoorMinutes,
  );

  @override
  List<Object?> get props => [
    calculation,
    alerts,
    reminderMinutes,
    methodChosenByUser,
    dailyReminders,
    fastReminderMinutes,
    fastKinds,
    suhoorMinutes,
  ];
}
