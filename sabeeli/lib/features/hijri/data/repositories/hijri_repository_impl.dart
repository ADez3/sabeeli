import 'package:injectable/injectable.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/hijri/hijri_calendar.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/hijri_settings.dart';
import '../../domain/repositories/hijri_repository.dart';
import '../datasources/hijri_local_data_source.dart';

@LazySingleton(as: HijriRepository)
class HijriRepositoryImpl implements HijriRepository {
  const HijriRepositoryImpl(this._local);
  final HijriLocalDataSource _local;

  @override
  Future<Result<HijriSettings>> loadSettings() async {
    try {
      return Ok(_local.readSettings());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> saveSettings(HijriSettings settings) async {
    try {
      await _local.writeSettings(settings);
      return const Ok(null);
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<HijriCalendar>> calendarFor(HijriSettings settings) async {
    HijriCalendar base = const TabularHijriCalendar();
    if (settings.method == HijriMethod.ummAlQura) {
      try {
        base = await _local.ummAlQura();
      } catch (_) {
        // The table is a bundled asset, so this only fails in a broken build; the
        // arithmetical calendar is within a day of it and keeps the app usable.
      }
    }
    return Ok(
      AdjustedHijriCalendar(
        base: base,
        dayOffset: settings.dayOffset,
        monthOverrides: settings.monthOverrides,
      ),
    );
  }
}
