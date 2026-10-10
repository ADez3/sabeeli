import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/astronomy/prayer.dart';
import 'package:sabeeli/features/prayer_times/data/models/prayer_settings_model.dart';
import 'package:sabeeli/features/prayer_times/domain/entities/prayer_settings.dart';

void main() {
  test('settings, daily reminders included, survive a round trip', () {
    final settings = PrayerSettings(
      reminderMinutes: 10,
      alerts: {
        ...PrayerSettings.defaultAlerts,
        Prayer.isha: PrayerAlert.silent,
      },
      dailyReminders: {
        DailyReminder.morningAzkar: 7 * 60,
        DailyReminder.quran: 20 * 60 + 30,
      },
    );
    final json = jsonDecode(
      jsonEncode(PrayerSettingsModel.toJson(settings)),
    ) as Map<String, dynamic>;
    expect(PrayerSettingsModel.fromJson(json), settings);
  });

  test('settings saved before daily reminders existed load with none on', () {
    final json = PrayerSettingsModel.toJson(const PrayerSettings())
      ..remove('daily');
    expect(PrayerSettingsModel.fromJson(json).dailyReminders, isEmpty);
  });

  test('an unknown reminder from a newer version is ignored', () {
    final json = PrayerSettingsModel.toJson(const PrayerSettings())
      ..['daily'] = {'morningAzkar': 420, 'somethingNew': 60};
    expect(PrayerSettingsModel.fromJson(json).dailyReminders, {
      DailyReminder.morningAzkar: 420,
    });
  });
}
