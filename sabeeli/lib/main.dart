import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/hijri/presentation/cubit/hijri_cubit.dart';
import 'features/location/presentation/cubit/location_cubit.dart';
import 'features/prayer_times/data/datasources/prayer_notification_data_source.dart';
import 'features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Everything the first frame shows is read before it, so nothing flickers from a
  // default to the stored value. All of it is local and takes milliseconds.
  await Future.wait([
    getIt<SettingsCubit>().load(),
    getIt<LocationCubit>().load(),
    getIt<HijriCubit>().load(),
    getIt<PrayerTimesCubit>().load(),
  ]);

  final notifications = getIt<PrayerNotificationDataSource>();
  await notifications.initialize(onTap: _openFromNotification);

  runApp(const SabeeliApp());

  // Launched by tapping a prayer notification: land on the prayer screen.
  final payload = await notifications.launchPayload();
  if (payload != null) _openFromNotification(payload);
}

void _openFromNotification(String? payload) {
  if (payload == null) return;
  final target = normalizeDeepLink(Uri.parse(payload));
  if (target != null) appRouter.go(target);
}
