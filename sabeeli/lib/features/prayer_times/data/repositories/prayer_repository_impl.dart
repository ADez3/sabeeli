import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/notification_texts.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_notification_data_source.dart';
import '../datasources/prayer_settings_local_data_source.dart';

@LazySingleton(as: PrayerRepository)
class PrayerRepositoryImpl implements PrayerRepository {
  const PrayerRepositoryImpl(this._settings, this._notifications);

  final PrayerSettingsLocalDataSource _settings;
  final PrayerNotificationDataSource _notifications;

  /// iOS keeps at most 64 pending notifications: 6 days × (5 prayers + 5 reminders)
  /// stays under it. Android has no such cap, so it gets a longer runway in case
  /// the app is not opened for a while.
  static int get _scheduleDays => !kIsWeb && Platform.isAndroid ? 14 : 6;

  @override
  Future<Result<PrayerSettings>> loadSettings() =>
      _guard(() async => _settings.read());

  @override
  Future<Result<void>> saveSettings(PrayerSettings settings) =>
      _guard(() => _settings.write(settings));

  @override
  Result<List<PrayerTimes>> calculate({
    required Coordinates coordinates,
    required DateTime from,
    required int days,
    required CalculationParameters parameters,
  }) {
    try {
      return Ok([
        for (var i = 0; i < days; i++)
          PrayerCalculator.calculate(
            coordinates: coordinates,
            date: DateTime(from.year, from.month, from.day + i),
            parameters: parameters,
          ),
      ]);
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<int>> scheduleNotifications({
    required Coordinates coordinates,
    required PrayerSettings settings,
    required NotificationTexts texts,
  }) => _guard(() async {
    final days = calculate(
      coordinates: coordinates,
      from: DateTime.now(),
      days: _scheduleDays,
      parameters: settings.calculation,
    ).valueOrNull;
    if (days == null) return 0;
    return _notifications.schedule(
      days: days,
      settings: settings,
      texts: texts,
    );
  });

  @override
  Future<Result<NotificationPermissions>> permissions() =>
      _guard(_notifications.permissions);

  @override
  Future<Result<NotificationPermissions>> requestPermissions() =>
      _guard(_notifications.requestPermissions);

  @override
  Future<Result<NotificationPermissions>> requestExactAlarms() =>
      _guard(_notifications.requestExactAlarms);

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }
}
