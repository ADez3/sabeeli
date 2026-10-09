import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/calculation_method.dart';
import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../location/domain/entities/saved_location.dart';
import '../../domain/entities/notification_texts.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/usecases/prayer_usecases.dart';

enum PrayerStatus { initial, noLocation, ready, failed }

class PrayerTimesState extends Equatable {
  const PrayerTimesState({
    this.status = PrayerStatus.initial,
    this.settings = const PrayerSettings(),
    this.location,
    this.today,
    this.tomorrow,
    this.permissions,
    this.failure,
  });

  final PrayerStatus status;
  final PrayerSettings settings;
  final SavedLocation? location;
  final PrayerTimes? today;
  final PrayerTimes? tomorrow;
  final NotificationPermissions? permissions;
  final Failure? failure;

  /// The next prayer time (sunrise included) and when it is, rolling over to
  /// tomorrow's Fajr after Isha.
  ({Prayer prayer, DateTime time})? nextAfter(DateTime now) {
    final t = today;
    if (t == null) return null;
    final next = t.nextAfter(now);
    if (next != null) return (prayer: next, time: t.timeOf(next));
    final fajr = tomorrow?.fajr;
    return fajr == null ? null : (prayer: Prayer.fajr, time: fajr);
  }

  PrayerTimesState copyWith({
    PrayerStatus? status,
    PrayerSettings? settings,
    SavedLocation? location,
    PrayerTimes? today,
    PrayerTimes? tomorrow,
    NotificationPermissions? permissions,
    Failure? Function()? failure,
  }) => PrayerTimesState(
    status: status ?? this.status,
    settings: settings ?? this.settings,
    location: location ?? this.location,
    today: today ?? this.today,
    tomorrow: tomorrow ?? this.tomorrow,
    permissions: permissions ?? this.permissions,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    settings,
    location,
    today,
    tomorrow,
    permissions,
    failure,
  ];
}

/// Today's and tomorrow's times for the saved location, and their notification schedule.
///
/// It does not listen to other cubits; the shell forwards location changes and the
/// current UI language (for notification text) through [setLocation] and
/// [setNotificationTexts].
@lazySingleton
class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit(
    this._load,
    this._save,
    this._calculate,
    this._schedule,
    this._permission,
  ) : super(const PrayerTimesState());

  final LoadPrayerSettingsUseCase _load;
  final SavePrayerSettingsUseCase _save;
  final CalculatePrayerTimesUseCase _calculate;
  final SchedulePrayerNotificationsUseCase _schedule;
  final NotificationPermissionUseCase _permission;

  NotificationTexts? _texts;
  SchedulePrayerNotificationsParams? _lastScheduled;

  Future<void> load() async {
    final result = await _load(const NoParams());
    result.fold((_) {}, (settings) => emit(state.copyWith(settings: settings)));
    await refreshPermissions();
  }

  Future<void> setLocation(SavedLocation? location) async {
    if (location == null) {
      emit(state.copyWith(status: PrayerStatus.noLocation));
      return;
    }
    var settings = state.settings;
    if (!settings.methodChosenByUser && location.countryCode != null) {
      final method = CalculationMethod.forCountry(location.countryCode);
      if (method != settings.calculation.method) {
        settings = settings.copyWith(
          calculation: settings.calculation.copyWith(method: method),
        );
        await _save(settings);
      }
    }
    emit(state.copyWith(location: location, settings: settings));
    _recalculate();
    await _reschedule();
  }

  void setNotificationTexts(NotificationTexts texts) {
    if (texts == _texts) return;
    _texts = texts;
    _reschedule();
  }

  /// Called on resume and at midnight: rolls "today" forward and tops up the
  /// schedule so it never runs dry.
  Future<void> refresh() async {
    _recalculate();
    await refreshPermissions();
    await _reschedule(force: true);
  }

  Future<void> updateSettings(PrayerSettings settings) async {
    emit(state.copyWith(settings: settings));
    _recalculate();
    await _save(settings);
    await _reschedule();
  }

  Future<void> setMethod(CalculationMethod method) => updateSettings(
    state.settings.copyWith(
      calculation: state.settings.calculation.copyWith(method: method),
      methodChosenByUser: true,
    ),
  );

  Future<void> setAlert(Prayer prayer, PrayerAlert alert) async {
    if (alert != PrayerAlert.off &&
        !(state.permissions?.notificationsAllowed ?? false)) {
      await requestNotificationPermission();
    }
    await updateSettings(
      state.settings.copyWith(
        alerts: {...state.settings.alerts, prayer: alert},
      ),
    );
  }

  Future<void> refreshPermissions() async {
    final result = await _permission(PermissionRequest.check);
    result.fold((_) {}, (p) => emit(state.copyWith(permissions: p)));
  }

  Future<void> requestNotificationPermission() async {
    final result = await _permission(PermissionRequest.notifications);
    result.fold((_) {}, (p) => emit(state.copyWith(permissions: p)));
    await _reschedule(force: true);
  }

  Future<void> requestExactAlarms() async {
    final result = await _permission(PermissionRequest.exactAlarms);
    result.fold((_) {}, (p) => emit(state.copyWith(permissions: p)));
    await _reschedule(force: true);
  }

  /// Times for any day, for the day picker on the prayer screen.
  PrayerTimes? timesFor(DateTime day) {
    final location = state.location;
    if (location == null) return null;
    return _calculate(
      CalculatePrayerTimesParams(
        coordinates: location.coordinates,
        from: day,
        days: 1,
        parameters: state.settings.calculation,
      ),
    ).valueOrNull?.first;
  }

  void _recalculate() {
    final location = state.location;
    if (location == null) return;
    final result = _calculate(
      CalculatePrayerTimesParams(
        coordinates: location.coordinates,
        from: DateTime.now(),
        parameters: state.settings.calculation,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: PrayerStatus.failed, failure: () => failure),
      ),
      (days) => emit(
        state.copyWith(
          status: PrayerStatus.ready,
          today: days[0],
          tomorrow: days[1],
          failure: () => null,
        ),
      ),
    );
  }

  Future<void> _reschedule({bool force = false}) async {
    final location = state.location;
    final texts = _texts;
    if (location == null || texts == null) return;
    final params = SchedulePrayerNotificationsParams(
      coordinates: location.coordinates,
      settings: state.settings,
      texts: texts,
    );
    if (!force && params == _lastScheduled) return;
    _lastScheduled = params;
    await _schedule(params);
  }
}
