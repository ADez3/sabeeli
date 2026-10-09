import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/result/result.dart';
import '../entities/notification_texts.dart';
import '../entities/prayer_settings.dart';

abstract interface class PrayerRepository {
  Future<Result<PrayerSettings>> loadSettings();
  Future<Result<void>> saveSettings(PrayerSettings settings);

  /// Times for [days] consecutive local days starting at [from].
  Result<List<PrayerTimes>> calculate({
    required Coordinates coordinates,
    required DateTime from,
    required int days,
    required CalculationParameters parameters,
  });

  /// Replaces the scheduled prayer notifications. Returns how many notifications are now pending.
  Future<Result<int>> scheduleNotifications({
    required Coordinates coordinates,
    required PrayerSettings settings,
    required NotificationTexts texts,
  });

  Future<Result<NotificationPermissions>> permissions();
  Future<Result<NotificationPermissions>> requestPermissions();
  Future<Result<NotificationPermissions>> requestExactAlarms();
}
