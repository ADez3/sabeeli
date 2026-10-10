import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../astronomy/prayer.dart';
import '../../features/azkar/presentation/pages/dhikr_session_page.dart';
import '../../features/azkar/presentation/pages/dhikr_page.dart';
import '../../features/hijri/presentation/pages/hijri_settings_page.dart';
import '../../features/home/presentation/pages/today_page.dart';
import '../../features/location/presentation/pages/location_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_settings_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/prayer_times/presentation/pages/reminders_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/quran/domain/entities/quran_entities.dart';
import '../../features/quran/presentation/pages/quran_index_page.dart';
import '../../features/quran/presentation/pages/quran_reader_page.dart';
import '../../features/quran/presentation/pages/surah_opening_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/tasbih/presentation/pages/tasbih_page.dart';
import '../di/injection.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Pages pushed over the shell (the reader, settings…) use the root navigator so
/// they cover the bottom bar; the tab roots live inside it.
final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.today,
  redirect: (context, state) {
    final link = normalizeDeepLink(state.uri);
    if (link != null) return link;
    // The first launch starts with the welcome.
    final onboarded = getIt<SettingsCubit>().state.onboarded;
    // Its own sub-pages (the city search) stay reachable meanwhile.
    final path = state.uri.path;
    if (!onboarded &&
        path != AppRoutes.welcome &&
        !path.startsWith('${AppRoutes.welcome}/')) {
      return AppRoutes.welcome;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      name: AppRoutes.welcomeName,
      builder: (_, _) => const WelcomePage(),
      routes: [
        GoRoute(path: 'location', builder: (_, _) => const LocationPage()),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => ShellPage(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.today,
              name: AppRoutes.todayName,
              builder: (_, _) => const TodayPage(),
              routes: [
                GoRoute(
                  path: AppRoutes.prayer,
                  name: AppRoutes.prayerName,
                  parentNavigatorKey: rootNavigatorKey,
                  // The dive from the sky passes a fresh `dive` value, so the
                  // page is rebuilt and replays its arrival. The page animates
                  // itself; the route only cross-fades.
                  pageBuilder: (_, state) {
                    final dive = state.uri.queryParameters['dive'];
                    return CustomTransitionPage(
                      key: state.pageKey,
                      transitionDuration: const Duration(milliseconds: 220),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 320,
                      ),
                      child: PrayerTimesPage(
                        key: ValueKey(dive),
                        arrivedByDive: dive != null,
                      ),
                      transitionsBuilder: (_, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                    );
                  },
                ),
                GoRoute(
                  path: AppRoutes.hijri,
                  name: AppRoutes.hijriName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const HijriSettingsPage(),
                ),
                GoRoute(
                  path: AppRoutes.settings,
                  name: AppRoutes.settingsName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const SettingsPage(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.prayerSettings,
                      name: AppRoutes.prayerSettingsName,
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, _) => const PrayerSettingsPage(),
                    ),
                    GoRoute(
                      path: AppRoutes.location,
                      name: AppRoutes.locationName,
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, _) => const LocationPage(),
                    ),
                    GoRoute(
                      path: AppRoutes.reminders,
                      name: AppRoutes.remindersName,
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, _) => const RemindersPage(),
                    ),
                    GoRoute(
                      path: AppRoutes.about,
                      name: AppRoutes.aboutName,
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, _) => const AboutPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.quran,
              name: AppRoutes.quranName,
              builder: (_, _) => const QuranIndexPage(),
              routes: [
                GoRoute(
                  path: AppRoutes.quranIntro,
                  name: AppRoutes.quranIntroName,
                  parentNavigatorKey: rootNavigatorKey,
                  // Opening a star: the page fades in from a slight zoom.
                  pageBuilder: (_, state) => CustomTransitionPage(
                    key: state.pageKey,
                    transitionDuration: const Duration(milliseconds: 450),
                    child: SurahOpeningPage(
                      surah:
                          (int.tryParse(state.pathParameters['surah'] ?? '') ??
                                  1)
                              .clamp(1, 114),
                    ),
                    transitionsBuilder: (_, animation, _, child) =>
                        FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween(begin: 1.08, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: child,
                          ),
                        ),
                  ),
                ),
                GoRoute(
                  path: AppRoutes.quranPage,
                  name: AppRoutes.quranPageName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => QuranReaderPage(
                    page: int.tryParse(state.pathParameters['page'] ?? '')
                        ?.clamp(1, QuranData.pageCount),
                  ),
                ),
                GoRoute(
                  path: AppRoutes.quranSurah,
                  name: AppRoutes.quranSurahName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) {
                    final surah =
                        (int.tryParse(state.pathParameters['surah'] ?? '') ?? 1)
                            .clamp(1, 114);
                    final ayah = int.tryParse(
                      state.uri.queryParameters['ayah'] ?? '',
                    );
                    // Only an explicitly requested ayah is highlighted; a bare surah
                    // link just opens at its first page.
                    return QuranReaderPage(
                      ayah: AyahRef(surah, ayah == null || ayah < 1 ? 1 : ayah),
                      highlight: ayah != null,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.azkar,
              name: AppRoutes.azkarName,
              builder: (_, _) => const DhikrPage(),
              routes: [
                // Before `:categoryId`, which would otherwise match them.
                GoRoute(
                  path: AppRoutes.afterPrayer,
                  name: AppRoutes.afterPrayerName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => AfterPrayerPage(
                    prayer: Prayer.values
                        .asNameMap()[state.uri.queryParameters['prayer']],
                  ),
                ),
                GoRoute(
                  path: AppRoutes.tasbih,
                  name: AppRoutes.tasbihName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const TasbihPage(),
                ),
                GoRoute(
                  path: AppRoutes.azkarCategory,
                  name: AppRoutes.azkarCategoryName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => AzkarReaderPage(
                    categoryId:
                        int.tryParse(
                          state.pathParameters['categoryId'] ?? '',
                        ) ??
                        0,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.qibla,
              name: AppRoutes.qiblaName,
              builder: (_, _) => const QiblaPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Folds `sabeeli://quran/2?ayah=255` (which arrives with "quran" as the URI
/// host) into an app path, and keeps links from earlier versions of the app
/// working (`/prayer`, `/azkar/…`, `/more/…`). Returns null when nothing changes.
String? normalizeDeepLink(Uri uri) {
  final custom = uri.scheme == 'sabeeli';
  var path = custom ? '/${uri.host}${uri.path}' : uri.path;
  if (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  const settings = '${AppRoutes.today}/${AppRoutes.settings}';
  final mapped = switch (path) {
    '/' || '/home' => AppRoutes.today,
    '/prayer' => '${AppRoutes.today}/${AppRoutes.prayer}',
    '/prayer/settings' => '$settings/${AppRoutes.prayerSettings}',
    '/prayer/location' => '$settings/${AppRoutes.location}',
    '/more' || '/more/settings' => settings,
    '/more/about' => '$settings/${AppRoutes.about}',
    '/more/hijri' => '${AppRoutes.today}/${AppRoutes.hijri}',
    '/more/qibla' => AppRoutes.qibla,
    '/more/tasbih' => '${AppRoutes.azkar}/${AppRoutes.tasbih}',
    _ when path == '/azkar' || path.startsWith('/azkar/') =>
      AppRoutes.azkar + path.substring('/azkar'.length),
    _ => path,
  };
  if (!custom && mapped == uri.path) return null;
  return Uri(
    path: mapped,
    query: uri.query.isEmpty ? null : uri.query,
  ).toString();
}
