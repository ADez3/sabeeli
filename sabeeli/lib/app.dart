import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/numerals.dart';
import 'features/azkar/presentation/cubit/azkar_cubit.dart';
import 'features/hijri/presentation/cubit/hijri_cubit.dart';
import 'features/location/presentation/cubit/location_cubit.dart';
import 'features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'features/quran/presentation/cubit/quran_cubit.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
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
          return NumeralsScope(
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
            child: child!,
          );
        },
      ),
    ),
  );
}
