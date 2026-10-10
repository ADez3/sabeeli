import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/hijri/fasting.dart';
import '../../../../core/hijri/hijri_calendar.dart';
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
  static const payload = 'sabeeli://today/day';

  // Android freezes a channel's sound and importance when it is created, so changing
  // either needs a new channel id.
  static const _soundChannel = 'prayer_sound_v1';
  static const _silentChannel = 'prayer_silent_v1';
  static const _reminderChannel = 'reminder_v1';
  static const _dailyChannel = 'daily_v1';

  /// Where a daily reminder leads: the adhkar it is about, or the Quran.
  static const _dailyPayloads = {
    DailyReminder.morningAzkar: 'sabeeli://dhikr/1001',
    DailyReminder.eveningAzkar: 'sabeeli://dhikr/1002',
    DailyReminder.sleepAzkar: 'sabeeli://dhikr/28',
    DailyReminder.quran: 'sabeeli://quran',
  };
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
    HijriCalendar? hijri,
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
    // Every time of the scheduled days in order: a notification lasts until
    // the next one begins, so the shade holds the current prayer, not a pile.
    final times = [
      for (final day in days)
        for (final p in Prayer.values) day.timeOf(p),
    ];
    Duration? untilNext(DateTime at) {
      final i = times.indexOf(at);
      return i >= 0 && i + 1 < times.length
          ? times[i + 1].difference(at)
          : null;
    }

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
            notificationDetails: _details(alert, texts, untilNext(at)),
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
            notificationDetails: _reminderDetails(
              texts,
              // "Asr in 10 minutes" goes once Asr has come.
              at.difference(reminderAt),
            ),
            androidScheduleMode: mode,
            payload: payload,
          );
          count++;
        }
      }
    }
    count += await _scheduleDaily(settings, texts);
    if (hijri != null) {
      count += await _scheduleFasting(days, settings, texts, hijri, mode);
    }
    return count;
  }

  /// The evening before a voluntary fast, and the suhoor in Ramadan.
  Future<int> _scheduleFasting(
    List<PrayerTimes> days,
    PrayerSettings settings,
    NotificationTexts texts,
    HijriCalendar hijri,
    AndroidScheduleMode mode,
  ) async {
    var count = 0;
    final now = DateTime.now();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(_dailyChannel, texts.dailyChannel),
      iOS: const DarwinNotificationDetails(threadIdentifier: 'fasting'),
      macOS: const DarwinNotificationDetails(threadIdentifier: 'fasting'),
    );
    for (final (i, day) in days.indexed) {
      final date = DateTime(day.date.year, day.date.month, day.date.day);
      final fajr = day.fajr;

      final suhoor = settings.suhoorMinutes;
      if (suhoor != null &&
          Fasting.on(hijri, date).contains(FastKind.ramadan)) {
        final at = fajr.subtract(Duration(minutes: suhoor));
        if (at.isAfter(now)) {
          await _plugin.zonedSchedule(
            id: 900 + i * 2,
            title: texts.suhoorTitle,
            body: texts.suhoorBody,
            scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
            notificationDetails: details,
            androidScheduleMode: mode,
            payload: payload,
          );
          count++;
        }
      }

      final evening = settings.fastReminderMinutes;
      if (evening != null) {
        // Tonight, for tomorrow's fast.
        final tomorrow = date.add(const Duration(days: 1));
        final kinds = Fasting.on(
          hijri,
          tomorrow,
        ).intersection(settings.fastKinds);
        final at = date.add(Duration(minutes: evening));
        if (kinds.isNotEmpty && at.isAfter(now)) {
          final kind = FastKind.values.firstWhere(kinds.contains);
          await _plugin.zonedSchedule(
            id: 900 + i * 2 + 1,
            title: texts.fastTitles[kind],
            body: texts.fastBody,
            scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: payload,
          );
          count++;
        }
      }
    }
    return count;
  }

  /// Daily reminders repeat by themselves: one pending notification each,
  /// whatever the number of days (iOS keeps at most 64).
  Future<int> _scheduleDaily(
    PrayerSettings settings,
    NotificationTexts texts,
  ) async {
    var count = 0;
    final local = DateTime.now();
    for (final MapEntry(key: kind, value: minutes)
        in settings.dailyReminders.entries) {
      final text = texts.daily[kind];
      if (text == null) continue;
      var next = DateTime(
        local.year,
        local.month,
        local.day,
        minutes ~/ 60,
        minutes % 60,
      );
      if (!next.isAfter(local)) next = next.add(const Duration(days: 1));
      // Repeats at the same UTC time; rescheduled on every return to the app,
      // so a change of clock (summer time) is followed.
      await _plugin.zonedSchedule(
        id: 1000 + kind.index,
        title: text.$1,
        body: text.$2,
        scheduledDate: tz.TZDateTime.from(next.toUtc(), tz.UTC),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _dailyChannel,
            texts.dailyChannel,
            // Gone by the next day's, so the shade never collects them.
            timeoutAfter: const Duration(hours: 23).inMilliseconds,
          ),
          iOS: const DarwinNotificationDetails(threadIdentifier: 'daily'),
          macOS: const DarwinNotificationDetails(threadIdentifier: 'daily'),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: _dailyPayloads[kind],
      );
      count++;
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
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _dailyChannel,
        texts.dailyChannel,
        importance: Importance.defaultImportance,
      ),
    );
  }

  /// [lasts]: the notification removes itself when the next prayer begins.
  NotificationDetails _details(
    PrayerAlert alert,
    NotificationTexts texts,
    Duration? lasts,
  ) {
    final silent = alert == PrayerAlert.silent;
    final android = silent
        ? AndroidNotificationDetails(
            _silentChannel,
            texts.silentChannel,
            playSound: false,
            enableVibration: false,
            timeoutAfter: lasts?.inMilliseconds,
          )
        : AndroidNotificationDetails(
            _soundChannel,
            texts.prayerChannel,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            timeoutAfter: lasts?.inMilliseconds,
          );
    // iOS cannot expire a notification; prayers are at least kept together.
    final darwin = DarwinNotificationDetails(
      presentSound: !silent,
      interruptionLevel: InterruptionLevel.timeSensitive,
      threadIdentifier: 'prayers',
    );
    return NotificationDetails(android: android, iOS: darwin, macOS: darwin);
  }

  NotificationDetails _reminderDetails(
    NotificationTexts texts,
    Duration lasts,
  ) => NotificationDetails(
    android: AndroidNotificationDetails(
      _reminderChannel,
      texts.reminderChannel,
      timeoutAfter: lasts.inMilliseconds,
    ),
    iOS: const DarwinNotificationDetails(threadIdentifier: 'prayers'),
    macOS: const DarwinNotificationDetails(threadIdentifier: 'prayers'),
  );
}
