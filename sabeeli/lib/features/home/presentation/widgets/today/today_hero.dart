import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/astronomy/prayer.dart';
import '../../../../../core/platform/live_state.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/glass_panel.dart';
import '../../../../../core/widgets/rolling_digits.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../../hijri/presentation/widgets/hijri_labels.dart';
import '../../../../location/presentation/cubit/location_cubit.dart';
import '../../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../../prayer_times/presentation/widgets/prayer_labels.dart';

const _onSky = Colors.white;
final _onSkyMuted = Colors.white.withValues(alpha: 0.72);
final _skyShadow = [
  Shadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 24),
];

/// The words written across the sky: where and when, the next prayer with a
/// rolling countdown, and the day's five times along the horizon.
class TodayHeroContent extends StatelessWidget {
  const TodayHeroContent({super.key, required this.onDive});

  /// Opens the day (the prayer timeline), with the dive transition.
  final VoidCallback onDive;

  @override
  Widget build(BuildContext context) {
    final hasLocation = context.select(
      (LocationCubit c) => c.state.location != null,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TopBar(),
          const SizedBox(height: AppSpacing.xxl),
          if (hasLocation)
            _Countdown(onTap: onDive)
          else
            const _SetLocationPrompt(),
          const Spacer(),
          if (hasLocation) _PrayerStrip(onTap: onDive),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final location = context.select((LocationCubit c) => c.state.location);
    return Row(
      children: [
        if (location != null)
          Flexible(
            child: GlassPanel(
              radius: 20,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              onTap: () => context.pushNamed(AppRoutes.locationName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.mapPin, size: 15, color: _onSky),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      location.name ?? l10n.unknownPlace,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge?.copyWith(color: _onSky),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Spacer(),
        Tooltip(
          message: l10n.settings,
          child: GlassPanel(
            shape: BoxShape.circle,
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            onTap: () => context.pushNamed(AppRoutes.settingsName),
            child: const Icon(LucideIcons.settings2, size: 20, color: _onSky),
          ),
        ),
      ],
    );
  }
}

/// "Asr in" and the time left, large: hours and minutes, and seconds only in
/// the last minute. The timer wakes when the shown value changes (once a
/// minute) and not at all while the sky is out of sight.
class _Countdown extends StatefulWidget {
  const _Countdown({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> with LiveStateMixin {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void onLiveChanged(bool live) {
    _timer?.cancel();
    _timer = null;
    if (live) _tick();
  }

  void _tick() {
    if (!mounted) return;
    final now = DateTime.now();
    final prayers = context.read<PrayerTimesCubit>();
    final today = prayers.state.today?.date;
    if (today != null && (today.day != now.day || today.month != now.month)) {
      prayers.refresh();
    }
    setState(() => _now = now);
    _timer = Timer(_untilNextChange(now), _tick);
  }

  /// Until the displayed value changes: the next whole minute left, or the next
  /// second in the last minute.
  Duration _untilNextChange(DateTime now) {
    final next = context.read<PrayerTimesCubit>().state.nextAfter(now);
    if (next == null) return const Duration(minutes: 1);
    final left = next.time.difference(now).inMilliseconds;
    if (left <= 0) return const Duration(seconds: 1);
    final step = left <= 60000 ? 1000 : 60000;
    return Duration(milliseconds: left % step + 20);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final hijri = context.select((HijriCubit c) => c.state.today);
    final next = context.watch<PrayerTimesCubit>().state.nextAfter(_now);
    if (next == null) return const SizedBox(height: 160);
    var left = next.time.difference(_now);
    if (left.isNegative) left = Duration.zero;
    final width = MediaQuery.sizeOf(context).width;
    final big = (width * 0.24).clamp(72.0, 120.0);
    final number = text.displayLarge!.copyWith(
      fontSize: big,
      height: 1,
      color: _onSky,
      shadows: _skyShadow,
    );
    final unit = text.headlineSmall!.copyWith(
      fontWeight: FontWeight.w300,
      color: _onSkyMuted,
      shadows: _skyShadow,
    );

    // Minutes round up, like formatDuration: at 7:08 with Isha at 7:21 the
    // clock says 13 minutes, and the tiles below say the same.
    final minutesLeft = (left.inSeconds + 59) ~/ 60;
    // (value, unit) pairs: "1 h 05 min", "42 min", "35 s".
    final parts = <(String, String)>[
      if (left.inSeconds < 60)
        ('${left.inSeconds}', l10n.unitSeconds)
      else ...[
        if (minutesLeft >= 60) ('${minutesLeft ~/ 60}', l10n.unitHours),
        (
          minutesLeft >= 60
              ? (minutesLeft % 60).toString().padLeft(2, '0')
              : '$minutesLeft',
          l10n.unitMinutes,
        ),
      ],
    ];

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        label:
            '${l10n.prayerName(next.prayer)}, '
            '${l10n.timeUntil(context.formatDuration(left))}',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hijri != null)
              Text(
                context.formatHijri(hijri),
                style: text.labelLarge?.copyWith(color: _onSkyMuted),
              ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              switch ((hijri?.month == 9, next.prayer)) {
                (true, Prayer.maghrib) => l10n.iftarIn,
                (true, Prayer.fajr) => l10n.suhoorEndsIn,
                _ => l10n.prayerIn(
                  l10n.prayerName(next.prayer, on: next.time.toLocal()),
                ),
              },
              style: text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w300,
                color: _onSky,
                shadows: _skyShadow,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                for (final (value, label) in parts) ...[
                  RollingDigits(context.digits(value), style: number),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSpacing.xs,
                      end: AppSpacing.md,
                    ),
                    child: Text(label, style: unit),
                  ),
                ],
              ],
            ),
            Text(
              l10n.atTime(context.formatTime(next.time)),
              style: text.titleMedium?.copyWith(
                color: _onSkyMuted,
                fontWeight: FontWeight.w400,
                shadows: _skyShadow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The five prayers of the day on one glass line, the next one lit in amber.
class _PrayerStrip extends StatelessWidget {
  const _PrayerStrip({required this.onTap});

  final VoidCallback onTap;

  static const _amber = Color(0xFFF4B56A);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final state = context.watch<PrayerTimesCubit>().state;
    final today = state.today;
    if (today == null) return const SizedBox.shrink();
    final next = state.nextAfter(DateTime.now())?.prayer;

    return Semantics(
      button: true,
      label: l10n.yourDay,
      child: GlassPanel(
        radius: 26,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            for (final p in Prayer.values.where((p) => p.isObligatory))
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l10n.prayerName(p, on: today.date),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: text.labelSmall?.copyWith(
                        color: p == next ? _amber : _onSkyMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.formatTime(today.timeOf(p)),
                      style: text.titleSmall?.copyWith(
                        color: p == next ? _amber : _onSky,
                        fontWeight: p == next
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SetLocationPrompt extends StatelessWidget {
  const _SetLocationPrompt();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final busy = context.select(
      (LocationCubit c) => c.state.status == LocationStatus.locating,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.setLocation,
          style: text.displaySmall?.copyWith(color: _onSky),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.setLocationHint,
          style: text.bodyMedium?.copyWith(color: _onSkyMuted, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            GlassPanel(
              radius: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              onTap: busy
                  ? null
                  : () => context.read<LocationCubit>().locate(
                      context.languageCode,
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.locateFixed, size: 18, color: _onSky),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    busy ? l10n.locating : l10n.useCurrentLocation,
                    style: const TextStyle(color: _onSky),
                  ),
                ],
              ),
            ),
            GlassPanel(
              radius: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              onTap: () => context.pushNamed(AppRoutes.locationName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.search, size: 18, color: _onSky),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.searchCity, style: const TextStyle(color: _onSky)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
