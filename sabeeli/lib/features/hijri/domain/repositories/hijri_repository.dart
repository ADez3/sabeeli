import '../../../../core/hijri/hijri_calendar.dart';
import '../../../../core/result/result.dart';
import '../entities/hijri_settings.dart';

abstract interface class HijriRepository {
  Future<Result<HijriSettings>> loadSettings();
  Future<Result<void>> saveSettings(HijriSettings settings);

  /// The calendar the whole app should use, with the user's corrections applied.
  Future<Result<HijriCalendar>> calendarFor(HijriSettings settings);
}
