import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/hijri/hijri_calendar.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_texts.dart';
import '../entities/prayer_settings.dart';
import '../repositories/prayer_repository.dart';

class CalculatePrayerTimesParams extends Equatable {
  const CalculatePrayerTimesParams({
    required this.coordinates,
    required this.from,
    required this.parameters,
    this.days = 2,
  });

  final Coordinates coordinates;
  final DateTime from;
  final int days;
  final CalculationParameters parameters;

  @override
  List<Object?> get props => [coordinates, from, days, parameters];
}

class SchedulePrayerNotificationsParams extends Equatable {
  const SchedulePrayerNotificationsParams({
    required this.coordinates,
    required this.settings,
    required this.texts,
    this.hijri,
  });

  final Coordinates coordinates;
  final PrayerSettings settings;
  final NotificationTexts texts;

  /// The user's Hijri calendar, for the fasting reminders; null without one.
  final HijriCalendar? hijri;

  @override
  List<Object?> get props => [coordinates, settings, texts, hijri];
}

@injectable
class LoadPrayerSettingsUseCase implements UseCase<PrayerSettings, NoParams> {
  const LoadPrayerSettingsUseCase(this._repository);
  final PrayerRepository _repository;

  @override
  Future<Result<PrayerSettings>> call(NoParams params) =>
      _repository.loadSettings();
}

@injectable
class SavePrayerSettingsUseCase implements UseCase<void, PrayerSettings> {
  const SavePrayerSettingsUseCase(this._repository);
  final PrayerRepository _repository;

  @override
  Future<Result<void>> call(PrayerSettings params) =>
      _repository.saveSettings(params);
}

/// Synchronous on purpose: the maths takes microseconds, and the countdown and the
/// day picker call it often.
@injectable
class CalculatePrayerTimesUseCase {
  const CalculatePrayerTimesUseCase(this._repository);
  final PrayerRepository _repository;

  Result<List<PrayerTimes>> call(CalculatePrayerTimesParams params) =>
      _repository.calculate(
        coordinates: params.coordinates,
        from: params.from,
        days: params.days,
        parameters: params.parameters,
      );
}

@injectable
class SchedulePrayerNotificationsUseCase
    implements UseCase<int, SchedulePrayerNotificationsParams> {
  const SchedulePrayerNotificationsUseCase(this._repository);
  final PrayerRepository _repository;

  @override
  Future<Result<int>> call(SchedulePrayerNotificationsParams params) =>
      _repository.scheduleNotifications(
        coordinates: params.coordinates,
        settings: params.settings,
        texts: params.texts,
        hijri: params.hijri,
      );
}

enum PermissionRequest { check, notifications, exactAlarms }

@injectable
class NotificationPermissionUseCase
    implements UseCase<NotificationPermissions, PermissionRequest> {
  const NotificationPermissionUseCase(this._repository);
  final PrayerRepository _repository;

  @override
  Future<Result<NotificationPermissions>> call(PermissionRequest params) =>
      switch (params) {
        PermissionRequest.check => _repository.permissions(),
        PermissionRequest.notifications => _repository.requestPermissions(),
        PermissionRequest.exactAlarms => _repository.requestExactAlarms(),
      };
}
