import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../domain/entities/notification_texts.dart';
import '../../domain/entities/prayer_settings.dart';

/// Schedules prayer notifications as exact OS alarms, with the phone's own
/// notification sound.
///
/// There is no background job: prayer times are deterministic, so the next days are
/// all scheduled at once and the whole schedule is replaced whenever an input
/// changes (location, settings, language, a new day). The plugin's boot receiver
/// re-arms them after a reboot.
@lazySingleton
class PrayerNotificationDataSource {
  PrayerNotificationDataSource(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  /// Payload carried by every prayer notification; tapping one opens the prayer tab.
  static const payload = 'sabeeli://prayer';

  // Android freezes a channel's sound and importance when it is created, so changing
  // either needs a new channel id.
  static const _soundChannel = 'prayer_sound_v1';
  static const _silentChannel = 'prayer_silent_v1';
  static const _reminderChannel = 'reminder_v1';
  static const _retiredChannels = ['adhan_v1'];

  bool get _supported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  Future<void> initialize({void Function(String? payload)? onTap}) async {
    if (_initialized || !_supported) return;
    const darwin = DarwinInitializationSettings(
      // Permission is asked from the prayer screen, where the reason is visible.
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: darwin,
        macOS: darwin,
      ),
      onDidReceiveNotificationResponse: (r) => onTap?.call(r.payload),
    );
    _initialized = true;
  }

  /// The payload of the notification that launched the app from a cold start.
  Future<String?> launchPayload() async {
    if (!_supported) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse?.payload;
    }
    return null;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<NotificationPermissions> permissions() async {
    if (!_supported) {
      return const NotificationPermissions(
        notificationsAllowed: false,
        exactAlarmsAllowed: false,
      );
    }
    if (Platform.isAndroid) {
      final android = _android!;
      return NotificationPermissions(
        notificationsAllowed: await android.areNotificationsEnabled() ?? false,
        exactAlarmsAllowed:
            await android.canScheduleExactNotifications() ?? false,
      );
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final options = await ios?.checkPermissions();
    return NotificationPermissions(
      notificationsAllowed: options?.isEnabled ?? false,
      exactAlarmsAllowed: true,
    );
  }

  Future<NotificationPermissions> requestPermissions() async {
    if (!_supported) return permissions();
    if (Platform.isAndroid) {
      await _android!.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, sound: true, badge: false);
    } else if (Platform.isMacOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, sound: true, badge: false);
    }
    return permissions();
  }

  /// Opens the system page for "Alarms & reminders" (Android 12+).
  Future<NotificationPermissions> requestExactAlarms() async {
    if (_supported && Platform.isAndroid) {
      await _android!.requestExactAlarmsPermission();
    }
    return permissions();
  }

  /// Replaces every scheduled notification with the given days.
  Future<int> schedule({
    required List<PrayerTimes> days,
    required PrayerSettings settings,
    required NotificationTexts texts,
  }) async {
    if (!_supported) return 0;
    await _plugin.cancelAll();
    await _createChannels(texts);

    final perms = await permissions();
    if (!perms.notificationsAllowed) return 0;
    // Without the exact-alarm permission Android may deliver a few minutes late.
    final mode = perms.exactAlarmsAllowed
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final now = DateTime.now().toUtc();
    var count = 0;
    for (final (dayIndex, day) in days.indexed) {
      for (final prayer in Prayer.values) {
        final alert = settings.alertFor(prayer);
        if (alert == PrayerAlert.off) continue;
        final at = day.timeOf(prayer);
        // Two ids per prayer per day: the prayer itself and its reminder.
        final id = dayIndex * 20 + prayer.index * 2;

        if (at.isAfter(now)) {
          await _plugin.zonedSchedule(
            id: id,
            title: texts.titles[prayer],
            body: texts.bodies[prayer],
            scheduledDate: tz.TZDateTime.from(at, tz.UTC),
            notificationDetails: _details(alert, texts),
            androidScheduleMode: mode,
            payload: payload,
          );
          count++;
        }

        final reminderAt = at.subtract(
          Duration(minutes: settings.reminderMinutes),
        );
        if (settings.reminderMinutes > 0 &&
            prayer.isObligatory &&
            reminderAt.isAfter(now)) {
          await _plugin.zonedSchedule(
            id: id + 1,
            title: texts.titles[prayer],
            body: texts.reminders[prayer],
            scheduledDate: tz.TZDateTime.from(reminderAt, tz.UTC),
            notificationDetails: _reminderDetails(texts),
            androidScheduleMode: mode,
            payload: payload,
          );
          count++;
        }
      }
    }
    return count;
  }

  /// Creating an existing channel again only updates its name, which is how channel
  /// names follow a language change.
  Future<void> _createChannels(NotificationTexts texts) async {
    final android = _android;
    if (android == null) return;
    for (final id in _retiredChannels) {
      await android.deleteNotificationChannel(channelId: id);
    }
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _soundChannel,
        texts.prayerChannel,
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _silentChannel,
        texts.silentChannel,
        importance: Importance.defaultImportance,
        playSound: false,
        enableVibration: false,
      ),
    );
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _reminderChannel,
        texts.reminderChannel,
        importance: Importance.defaultImportance,
      ),
    );
  }

  NotificationDetails _details(PrayerAlert alert, NotificationTexts texts) {
    final silent = alert == PrayerAlert.silent;
    final android = silent
        ? AndroidNotificationDetails(
            _silentChannel,
            texts.silentChannel,
            playSound: false,
            enableVibration: false,
          )
        : AndroidNotificationDetails(
            _soundChannel,
            texts.prayerChannel,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
          );
    final darwin = DarwinNotificationDetails(
      presentSound: !silent,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    return NotificationDetails(android: android, iOS: darwin, macOS: darwin);
  }

  NotificationDetails _reminderDetails(NotificationTexts texts) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannel,
          texts.reminderChannel,
        ),
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
      );
}
