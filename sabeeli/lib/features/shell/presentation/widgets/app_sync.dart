import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/numerals.dart';
import '../../../../l10n/l10n.dart';
import '../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/presentation/widgets/prayer_labels.dart';

/// Keeps the app-wide cubits in step with each other and with the clock, so no cubit
/// has to listen to another:
///  * a new location → new prayer times and a new notification schedule;
///  * a language change → notification text in that language;
///  * returning to the app or crossing midnight → today rolls over and the schedule
///    is topped up.
class AppSync extends StatefulWidget {
  const AppSync({super.key, required this.child});

  final Widget child;

  @override
  State<AppSync> createState() => _AppSyncState();
}

class _AppSyncState extends State<AppSync> with WidgetsBindingObserver {
  Timer? _midnight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _armMidnight();
    final location = context.read<LocationCubit>();
    context.read<PrayerTimesCubit>().setLocation(location.state.location);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) location.refreshIfAutomatic(context.languageCode);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pushNotificationTexts();
  }

  void _pushNotificationTexts() {
    final prayer = context.read<PrayerTimesCubit>();
    prayer.setNotificationTexts(
      context.l10n.notificationTexts(
        reminderMinutes: prayer.state.settings.reminderMinutes,
        numerals: NumeralsScope.of(context),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    context.read<HijriCubit>().refreshDay();
    context.read<PrayerTimesCubit>().refresh();
    context.read<LocationCubit>().refreshIfAutomatic(context.languageCode);
    _armMidnight();
  }

  void _armMidnight() {
    _midnight?.cancel();
    final now = DateTime.now();
    final next = DateTime(now.year, now.month, now.day + 1, 0, 0, 5);
    _midnight = Timer(next.difference(now), () {
      if (!mounted) return;
      context.read<HijriCubit>().refreshDay();
      context.read<PrayerTimesCubit>().refresh();
      _armMidnight();
    });
  }

  @override
  void dispose() {
    _midnight?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: [
      BlocListener<LocationCubit, LocationState>(
        listenWhen: (a, b) => a.location != b.location,
        listener: (context, state) =>
            context.read<PrayerTimesCubit>().setLocation(state.location),
      ),
      BlocListener<PrayerTimesCubit, PrayerTimesState>(
        listenWhen: (a, b) =>
            a.settings.reminderMinutes != b.settings.reminderMinutes,
        listener: (_, _) => _pushNotificationTexts(),
      ),
    ],
    child: widget.child,
  );
}
