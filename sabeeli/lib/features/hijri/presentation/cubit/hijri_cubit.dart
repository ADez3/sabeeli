import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/hijri/hijri_calendar.dart';
import '../../../../core/hijri/hijri_date.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/hijri_settings.dart';
import '../../domain/usecases/hijri_usecases.dart';

class HijriState extends Equatable {
  const HijriState({
    this.settings = const HijriSettings(),
    this.calendar = const TabularHijriCalendar(),
    this.today,
  });

  final HijriSettings settings;
  final HijriCalendar calendar;
  final HijriDate? today;

  @override
  List<Object?> get props => [settings, calendar, today];
}

/// The app's Hijri calendar, with the user's corrections applied. App-wide, because
/// the home screen, the prayer screen and the settings all show the same date.
@lazySingleton
class HijriCubit extends Cubit<HijriState> {
  HijriCubit(this._load, this._save, this._build) : super(const HijriState());

  final LoadHijriSettingsUseCase _load;
  final SaveHijriSettingsUseCase _save;
  final BuildHijriCalendarUseCase _build;

  Future<void> load() async {
    final result = await _load(const NoParams());
    await _apply(result.valueOrNull ?? const HijriSettings(), persist: false);
  }

  /// The Hijri date rolls over at local midnight here. (Religiously the day begins
  /// at Maghrib; the prayer screen says so where it matters.)
  void refreshDay() => emit(
    HijriState(
      settings: state.settings,
      calendar: state.calendar,
      today: state.calendar.fromGregorian(DateTime.now()),
    ),
  );

  Future<void> setMethod(HijriMethod method) =>
      _apply(state.settings.copyWith(method: method));

  Future<void> setDayOffset(int offset) =>
      _apply(state.settings.copyWith(dayOffset: offset.clamp(-2, 2)));

  /// Pins (or with null, unpins) the first day of a month.
  Future<void> setMonthStart(int monthIndex, DateTime? start) {
    final overrides = {...state.settings.monthOverrides};
    if (start == null) {
      overrides.remove(monthIndex);
    } else {
      overrides[monthIndex] = DateTime(start.year, start.month, start.day);
    }
    return _apply(state.settings.copyWith(monthOverrides: overrides));
  }

  Future<void> resetAll() => _apply(const HijriSettings());

  /// The month's start as computed without a pin on it, so the settings screen can
  /// offer "one day earlier / later" relative to it.
  DateTime unpinnedMonthStart(int monthIndex) {
    final settings = state.settings;
    final withoutPin = {...settings.monthOverrides}..remove(monthIndex);
    final calendar = state.calendar;
    final base = calendar is AdjustedHijriCalendar ? calendar.base : calendar;
    return dateFromJulianDayNumber(
      AdjustedHijriCalendar(
        base: base,
        dayOffset: settings.dayOffset,
        monthOverrides: withoutPin,
      ).monthStartJdn(monthIndex),
    );
  }

  Future<void> _apply(HijriSettings settings, {bool persist = true}) async {
    final result = await _build(settings);
    final calendar = result.valueOrNull ?? const TabularHijriCalendar();
    emit(
      HijriState(
        settings: settings,
        calendar: calendar,
        today: calendar.fromGregorian(DateTime.now()),
      ),
    );
    if (persist) await _save(settings);
  }
}
