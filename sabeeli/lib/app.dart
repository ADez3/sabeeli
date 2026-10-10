import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/sky_ambience.dart';
import 'core/utils/numerals.dart';
import 'features/azkar/presentation/cubit/azkar_cubit.dart';
import 'features/feedback/presentation/widgets/shake_to_report.dart';
import 'features/hijri/presentation/cubit/hijri_cubit.dart';
import 'features/location/presentation/cubit/location_cubit.dart';
import 'features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'features/quran/presentation/cubit/quran_cubit.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/shell/presentation/widgets/app_sync.dart';
import 'l10n/l10n.dart';

class SabeeliApp extends StatelessWidget {
  const SabeeliApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    // App-wide state, created once in DI and shared by every screen.
    providers: [
      BlocProvider.value(value: getIt<SettingsCubit>()),
      BlocProvider.value(value: getIt<LocationCubit>()),
      BlocProvider.value(value: getIt<PrayerTimesCubit>()),
      BlocProvider.value(value: getIt<HijriCubit>()),
      BlocProvider.value(value: getIt<QuranCubit>()),
      BlocProvider.value(value: getIt<AzkarCubit>()),
    ],
    child: BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) => MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: settings.themeMode,
        locale: settings.languageCode == null
            ? null
            : Locale(settings.languageCode!),
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: appRouter,
        builder: (context, child) {
          final locationCountry = context.select(
            (LocationCubit c) => c.state.location?.countryCode,
          );
          final where = context.select(
            (LocationCubit c) => c.state.location?.coordinates,
          );
          // The phone's font size is honoured within a range: beyond 1.3 the
          // fixed rows (the navigation capsule, the prayer strip, chips) clip
          // their labels; below 0.9 secondary text stops being legible.
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 0.9,
            maxScaleFactor: 1.3,
            child: SkyAmbience(
              where: where,
              child: NumeralsScope(
                numerals: Numerals.resolve(
                  settings.numeralStyle,
                  languageCode: Localizations.localeOf(context).languageCode,
                  // The phone's region first (a Moroccan phone in French is still
                  // Moroccan), then the country of the saved location.
                  countryCode:
                      WidgetsBinding
                          .instance
                          .platformDispatcher
                          .locale
                          .countryCode ??
                      locationCountry,
                ),
                // AppSync sits above the router so it runs whatever the first
                // route is: a notification or a link can open a page pushed
                // over the shell, and the shell is not built under it.
                child: ShakeToReport(child: AppSync(child: child!)),
              ),
            ),
          );
        },
      ),
    ),
  );
}
