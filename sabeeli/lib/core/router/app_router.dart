import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/azkar/presentation/pages/azkar_categories_page.dart';
import '../../features/azkar/presentation/pages/azkar_reader_page.dart';
import '../../features/hijri/presentation/pages/hijri_settings_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/location/presentation/pages/location_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_settings_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/quran/domain/entities/quran_entities.dart';
import '../../features/quran/presentation/pages/quran_index_page.dart';
import '../../features/quran/presentation/pages/quran_reader_page.dart';
import '../../features/quran/presentation/pages/surah_opening_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/more_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/tasbih/presentation/pages/tasbih_page.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Pages pushed over the shell (the reader, settings…) use the root navigator so
/// they cover the bottom bar; the tab roots live inside it.
final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  redirect: (context, state) => normalizeDeepLink(state.uri),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => ShellPage(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: AppRoutes.homeName,
              builder: (_, _) => const HomePage(),
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
              path: AppRoutes.prayer,
              name: AppRoutes.prayerName,
              // The dive from the home sky passes a fresh `dive` value, so the page is
              // rebuilt and replays its arrival.
              builder: (_, state) {
                final dive = state.uri.queryParameters['dive'];
                return PrayerTimesPage(
                  key: ValueKey(dive),
                  arrivedByDive: dive != null,
                );
              },
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
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.azkar,
              name: AppRoutes.azkarName,
              builder: (_, _) => const AzkarCategoriesPage(),
              routes: [
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
              path: AppRoutes.more,
              name: AppRoutes.moreName,
              builder: (_, _) => const MorePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.qibla,
                  name: AppRoutes.qiblaName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const QiblaPage(),
                ),
                GoRoute(
                  path: AppRoutes.tasbih,
                  name: AppRoutes.tasbihName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const TasbihPage(),
                ),
                GoRoute(
                  path: AppRoutes.settings,
                  name: AppRoutes.settingsName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const SettingsPage(),
                ),
                GoRoute(
                  path: AppRoutes.hijri,
                  name: AppRoutes.hijriName,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const HijriSettingsPage(),
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
  ],
);

/// `sabeeli://quran/2?ayah=255` arrives with "quran" as the URI host, not part of
/// the path; fold it back into an app path. Anything else passes through.
String? normalizeDeepLink(Uri uri) {
  if (uri.scheme != 'sabeeli') return null;
  final path = '/${uri.host}${uri.path}';
  return Uri(
    path: path,
    query: uri.query.isEmpty ? null : uri.query,
  ).toString();
}
