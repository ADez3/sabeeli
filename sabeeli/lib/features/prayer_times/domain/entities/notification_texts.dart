import 'package:equatable/equatable.dart';

import '../../../../core/astronomy/prayer.dart';
import 'prayer_settings.dart';

/// Localized strings for scheduled notifications.
///
/// Notifications are rendered by the OS long after the app has gone, so their text
/// is resolved at scheduling time from the current UI language and handed down.
class NotificationTexts extends Equatable {
  const NotificationTexts({
    required this.titles,
    required this.bodies,
    required this.reminders,
    required this.silentChannel,
    required this.prayerChannel,
    required this.reminderChannel,
    this.daily = const {},
    this.dailyChannel = '',
    this.fastTitles = const {},
    this.fastBody = '',
    this.suhoorTitle = '',
    this.suhoorBody = '',
  });

  final Map<Prayer, String> titles;
  final Map<Prayer, String> bodies;

  /// "Asr in 10 minutes", already filled with the reminder length.
  final Map<Prayer, String> reminders;
  final String silentChannel;
  final String prayerChannel;
  final String reminderChannel;

  /// Title and body of each daily reminder.
  final Map<DailyReminder, (String, String)> daily;
  final String dailyChannel;

  /// "Tomorrow: Monday fast" and so on, per kind; [fastBody] under it.
  final Map<FastKind, String> fastTitles;
  final String fastBody;

  /// The suhoor reminder in Ramadan ("Fajr in 45 minutes").
  final String suhoorTitle;
  final String suhoorBody;

  @override
  List<Object?> get props => [
    titles,
    bodies,
    reminders,
    silentChannel,
    prayerChannel,
    reminderChannel,
    daily,
    dailyChannel,
    fastTitles,
    fastBody,
    suhoorTitle,
    suhoorBody,
  ];
}

class NotificationPermissions extends Equatable {
  const NotificationPermissions({
    required this.notificationsAllowed,
    required this.exactAlarmsAllowed,
  });

  final bool notificationsAllowed;

  /// Android 12+: without it alarms may be delayed by several minutes.
  final bool exactAlarmsAllowed;

  @override
  List<Object?> get props => [notificationsAllowed, exactAlarmsAllowed];
}
