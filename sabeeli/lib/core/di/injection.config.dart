// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/azkar/data/datasources/azkar_asset_data_source.dart'
    as _i5;
import '../../features/azkar/data/repositories/azkar_repository_impl.dart'
    as _i3;
import '../../features/azkar/domain/repositories/azkar_repository.dart'
    as _i598;
import '../../features/azkar/domain/usecases/get_azkar_categories_usecase.dart'
    as _i438;
import '../../features/azkar/presentation/cubit/azkar_cubit.dart' as _i223;
import '../../features/hijri/data/datasources/hijri_local_data_source.dart'
    as _i544;
import '../../features/hijri/data/repositories/hijri_repository_impl.dart'
    as _i557;
import '../../features/hijri/domain/repositories/hijri_repository.dart'
    as _i745;
import '../../features/hijri/domain/usecases/hijri_usecases.dart' as _i781;
import '../../features/hijri/presentation/cubit/hijri_cubit.dart' as _i287;
import '../../features/location/data/datasources/device_location_data_source.dart'
    as _i148;
import '../../features/location/data/datasources/geocoding_remote_data_source.dart'
    as _i984;
import '../../features/location/data/datasources/location_local_data_source.dart'
    as _i632;
import '../../features/location/data/repositories/location_repository_impl.dart'
    as _i115;
import '../../features/location/domain/repositories/location_repository.dart'
    as _i332;
import '../../features/location/domain/usecases/location_usecases.dart' as _i90;
import '../../features/location/presentation/cubit/location_cubit.dart'
    as _i181;
import '../../features/prayer_times/data/datasources/prayer_notification_data_source.dart'
    as _i431;
import '../../features/prayer_times/data/datasources/prayer_settings_local_data_source.dart'
    as _i631;
import '../../features/prayer_times/data/repositories/prayer_repository_impl.dart'
    as _i616;
import '../../features/prayer_times/domain/repositories/prayer_repository.dart'
    as _i123;
import '../../features/prayer_times/domain/usecases/prayer_usecases.dart'
    as _i169;
import '../../features/prayer_times/presentation/cubit/prayer_times_cubit.dart'
    as _i1041;
import '../../features/qibla/data/datasources/compass_data_source.dart'
    as _i173;
import '../../features/qibla/data/repositories/qibla_repository_impl.dart'
    as _i232;
import '../../features/qibla/domain/repositories/qibla_repository.dart'
    as _i994;
import '../../features/qibla/domain/usecases/watch_compass_usecase.dart'
    as _i542;
import '../../features/qibla/presentation/cubit/qibla_cubit.dart' as _i614;
import '../../features/quran/data/datasources/quran_asset_data_source.dart'
    as _i245;
import '../../features/quran/data/datasources/quran_local_data_source.dart'
    as _i380;
import '../../features/quran/data/datasources/translation_remote_data_source.dart'
    as _i61;
import '../../features/quran/data/repositories/quran_repository_impl.dart'
    as _i82;
import '../../features/quran/domain/repositories/quran_repository.dart'
    as _i498;
import '../../features/quran/domain/usecases/quran_usecases.dart' as _i34;
import '../../features/quran/presentation/cubit/ayah_details_cubit.dart'
    as _i443;
import '../../features/quran/presentation/cubit/quran_cubit.dart' as _i432;
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/settings_usecases.dart'
    as _i279;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/tasbih/data/datasources/tasbih_local_data_source.dart'
    as _i885;
import '../../features/tasbih/data/repositories/tasbih_repository_impl.dart'
    as _i349;
import '../../features/tasbih/domain/repositories/tasbih_repository.dart'
    as _i164;
import '../../features/tasbih/domain/usecases/tasbih_usecases.dart' as _i206;
import '../../features/tasbih/presentation/cubit/tasbih_cubit.dart' as _i132;
import '../network/http_json.dart' as _i932;
import '../storage/key_value_store.dart' as _i892;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.preferences,
      preResolve: true,
    );
    gh.factory<_i223.AzkarSessionCubit>(() => _i223.AzkarSessionCubit());
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => registerModule.notifications,
    );
    gh.lazySingleton<_i932.HttpJson>(() => _i932.HttpJson());
    gh.lazySingleton<_i5.AzkarAssetDataSource>(
      () => _i5.AzkarAssetDataSource(),
    );
    gh.lazySingleton<_i148.DeviceLocationDataSource>(
      () => _i148.DeviceLocationDataSource(),
    );
    gh.lazySingleton<_i173.CompassDataSource>(() => _i173.CompassDataSource());
    gh.lazySingleton<_i245.QuranAssetDataSource>(
      () => _i245.QuranAssetDataSource(),
    );
    gh.lazySingleton<_i984.GeocodingRemoteDataSource>(
      () => _i984.GeocodingRemoteDataSource(gh<_i932.HttpJson>()),
    );
    gh.lazySingleton<_i61.TranslationRemoteDataSource>(
      () => _i61.TranslationRemoteDataSource(gh<_i932.HttpJson>()),
    );
    gh.lazySingleton<_i892.KeyValueStore>(
      () => _i892.KeyValueStore(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i598.AzkarRepository>(
      () => _i3.AzkarRepositoryImpl(gh<_i5.AzkarAssetDataSource>()),
    );
    gh.lazySingleton<_i431.PrayerNotificationDataSource>(
      () => _i431.PrayerNotificationDataSource(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
      ),
    );
    gh.lazySingleton<_i994.QiblaRepository>(
      () => _i232.QiblaRepositoryImpl(gh<_i173.CompassDataSource>()),
    );
    gh.factory<_i542.WatchCompassUseCase>(
      () => _i542.WatchCompassUseCase(gh<_i994.QiblaRepository>()),
    );
    gh.lazySingleton<_i544.HijriLocalDataSource>(
      () => _i544.HijriLocalDataSource(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i632.LocationLocalDataSource>(
      () => _i632.LocationLocalDataSource(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i631.PrayerSettingsLocalDataSource>(
      () => _i631.PrayerSettingsLocalDataSource(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i380.QuranLocalDataSource>(
      () => _i380.QuranLocalDataSource(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i599.SettingsLocalDataSource>(
      () => _i599.SettingsLocalDataSource(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i885.TasbihLocalDataSource>(
      () => _i885.TasbihLocalDataSource(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i164.TasbihRepository>(
      () => _i349.TasbihRepositoryImpl(gh<_i885.TasbihLocalDataSource>()),
    );
    gh.factory<_i614.QiblaCubit>(
      () => _i614.QiblaCubit(gh<_i542.WatchCompassUseCase>()),
    );
    gh.lazySingleton<_i498.QuranRepository>(
      () => _i82.QuranRepositoryImpl(
        gh<_i245.QuranAssetDataSource>(),
        gh<_i380.QuranLocalDataSource>(),
        gh<_i61.TranslationRemoteDataSource>(),
      ),
    );
    gh.factory<_i438.GetAzkarCategoriesUseCase>(
      () => _i438.GetAzkarCategoriesUseCase(gh<_i598.AzkarRepository>()),
    );
    gh.lazySingleton<_i123.PrayerRepository>(
      () => _i616.PrayerRepositoryImpl(
        gh<_i631.PrayerSettingsLocalDataSource>(),
        gh<_i431.PrayerNotificationDataSource>(),
      ),
    );
    gh.factory<_i206.LoadTasbihUseCase>(
      () => _i206.LoadTasbihUseCase(gh<_i164.TasbihRepository>()),
    );
    gh.factory<_i206.SaveTasbihUseCase>(
      () => _i206.SaveTasbihUseCase(gh<_i164.TasbihRepository>()),
    );
    gh.lazySingleton<_i223.AzkarCubit>(
      () => _i223.AzkarCubit(gh<_i438.GetAzkarCategoriesUseCase>()),
    );
    gh.factory<_i169.LoadPrayerSettingsUseCase>(
      () => _i169.LoadPrayerSettingsUseCase(gh<_i123.PrayerRepository>()),
    );
    gh.factory<_i169.SavePrayerSettingsUseCase>(
      () => _i169.SavePrayerSettingsUseCase(gh<_i123.PrayerRepository>()),
    );
    gh.factory<_i169.CalculatePrayerTimesUseCase>(
      () => _i169.CalculatePrayerTimesUseCase(gh<_i123.PrayerRepository>()),
    );
    gh.factory<_i169.SchedulePrayerNotificationsUseCase>(
      () => _i169.SchedulePrayerNotificationsUseCase(
        gh<_i123.PrayerRepository>(),
      ),
    );
    gh.factory<_i169.NotificationPermissionUseCase>(
      () => _i169.NotificationPermissionUseCase(gh<_i123.PrayerRepository>()),
    );
    gh.factory<_i132.TasbihCubit>(
      () => _i132.TasbihCubit(
        gh<_i206.LoadTasbihUseCase>(),
        gh<_i206.SaveTasbihUseCase>(),
      ),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i599.SettingsLocalDataSource>()),
    );
    gh.factory<_i34.LoadQuranUseCase>(
      () => _i34.LoadQuranUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.GetEditionsUseCase>(
      () => _i34.GetEditionsUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.GetEditionTextUseCase>(
      () => _i34.GetEditionTextUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.DownloadEditionUseCase>(
      () => _i34.DownloadEditionUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.GetBookmarksUseCase>(
      () => _i34.GetBookmarksUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.ToggleBookmarkUseCase>(
      () => _i34.ToggleBookmarkUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.GetReadingPositionUseCase>(
      () => _i34.GetReadingPositionUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.SaveReadingPositionUseCase>(
      () => _i34.SaveReadingPositionUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.GetReaderPreferencesUseCase>(
      () => _i34.GetReaderPreferencesUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.SaveReaderPreferencesUseCase>(
      () => _i34.SaveReaderPreferencesUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.GetReadPagesUseCase>(
      () => _i34.GetReadPagesUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i34.MarkPageReadUseCase>(
      () => _i34.MarkPageReadUseCase(gh<_i498.QuranRepository>()),
    );
    gh.factory<_i279.LoadAppSettingsUseCase>(
      () => _i279.LoadAppSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.factory<_i279.SaveAppSettingsUseCase>(
      () => _i279.SaveAppSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i745.HijriRepository>(
      () => _i557.HijriRepositoryImpl(gh<_i544.HijriLocalDataSource>()),
    );
    gh.factory<_i781.LoadHijriSettingsUseCase>(
      () => _i781.LoadHijriSettingsUseCase(gh<_i745.HijriRepository>()),
    );
    gh.factory<_i781.SaveHijriSettingsUseCase>(
      () => _i781.SaveHijriSettingsUseCase(gh<_i745.HijriRepository>()),
    );
    gh.factory<_i781.BuildHijriCalendarUseCase>(
      () => _i781.BuildHijriCalendarUseCase(gh<_i745.HijriRepository>()),
    );
    gh.lazySingleton<_i332.LocationRepository>(
      () => _i115.LocationRepositoryImpl(
        gh<_i148.DeviceLocationDataSource>(),
        gh<_i984.GeocodingRemoteDataSource>(),
        gh<_i632.LocationLocalDataSource>(),
      ),
    );
    gh.factory<_i443.AyahDetailsCubit>(
      () => _i443.AyahDetailsCubit(
        gh<_i34.GetEditionsUseCase>(),
        gh<_i34.GetEditionTextUseCase>(),
        gh<_i34.DownloadEditionUseCase>(),
      ),
    );
    gh.lazySingleton<_i432.QuranCubit>(
      () => _i432.QuranCubit(
        gh<_i34.LoadQuranUseCase>(),
        gh<_i34.GetBookmarksUseCase>(),
        gh<_i34.ToggleBookmarkUseCase>(),
        gh<_i34.GetReadingPositionUseCase>(),
        gh<_i34.SaveReadingPositionUseCase>(),
        gh<_i34.GetReaderPreferencesUseCase>(),
        gh<_i34.SaveReaderPreferencesUseCase>(),
        gh<_i34.GetReadPagesUseCase>(),
        gh<_i34.MarkPageReadUseCase>(),
      ),
    );
    gh.lazySingleton<_i287.HijriCubit>(
      () => _i287.HijriCubit(
        gh<_i781.LoadHijriSettingsUseCase>(),
        gh<_i781.SaveHijriSettingsUseCase>(),
        gh<_i781.BuildHijriCalendarUseCase>(),
      ),
    );
    gh.lazySingleton<_i1041.PrayerTimesCubit>(
      () => _i1041.PrayerTimesCubit(
        gh<_i169.LoadPrayerSettingsUseCase>(),
        gh<_i169.SavePrayerSettingsUseCase>(),
        gh<_i169.CalculatePrayerTimesUseCase>(),
        gh<_i169.SchedulePrayerNotificationsUseCase>(),
        gh<_i169.NotificationPermissionUseCase>(),
      ),
    );
    gh.factory<_i90.GetSavedLocationUseCase>(
      () => _i90.GetSavedLocationUseCase(gh<_i332.LocationRepository>()),
    );
    gh.factory<_i90.LocateDeviceUseCase>(
      () => _i90.LocateDeviceUseCase(gh<_i332.LocationRepository>()),
    );
    gh.factory<_i90.SearchPlacesUseCase>(
      () => _i90.SearchPlacesUseCase(gh<_i332.LocationRepository>()),
    );
    gh.factory<_i90.SaveLocationUseCase>(
      () => _i90.SaveLocationUseCase(gh<_i332.LocationRepository>()),
    );
    gh.lazySingleton<_i792.SettingsCubit>(
      () => _i792.SettingsCubit(
        gh<_i279.LoadAppSettingsUseCase>(),
        gh<_i279.SaveAppSettingsUseCase>(),
      ),
    );
    gh.lazySingleton<_i181.LocationCubit>(
      () => _i181.LocationCubit(
        gh<_i90.GetSavedLocationUseCase>(),
        gh<_i90.LocateDeviceUseCase>(),
        gh<_i90.SaveLocationUseCase>(),
        gh<_i332.LocationRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
