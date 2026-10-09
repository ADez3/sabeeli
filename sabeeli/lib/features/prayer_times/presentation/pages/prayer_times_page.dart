import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../hijri/presentation/widgets/hijri_labels.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../domain/entities/prayer_settings.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/location_chip.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_labels.dart';
import '../widgets/set_location_card.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  /// Days from today shown in the list; the hero card always shows the real next prayer.
  int _dayOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<PrayerTimesCubit>().state;
    final hasLocation = context.select(
      (LocationCubit c) => c.state.location != null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTimes),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.pushNamed(AppRoutes.prayerSettingsName),
          ),
        ],
      ),
      body: !hasLocation
          ? const ContentWidth(child: SetLocationCard(expanded: true))
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                ContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: LocationChip(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const NextPrayerCard(),
                      const _PermissionBanner(),
                      const SizedBox(height: AppSpacing.lg),
                      _DayPicker(
                        offset: _dayOffset,
                        onChanged: (v) => setState(() => _dayOffset = v),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (state.status == PrayerStatus.ready)
                        _PrayerList(
                          times: _dayOffset == 0
                              ? state.today!
                              : context.read<PrayerTimesCubit>().timesFor(
                                  DateTime.now().add(
                                    Duration(days: _dayOffset),
                                  ),
                                )!,
                          isToday: _dayOffset == 0,
                          settings: state.settings,
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({required this.offset, required this.onChanged});

  final int offset;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final day = DateTime.now().add(Duration(days: offset));
    final hijri = context
        .select((HijriCubit c) => c.state.calendar)
        .fromGregorian(day);
    final label = switch (offset) {
      0 => l10n.today,
      1 => l10n.tomorrow,
      _ => context.formatWeekdayDate(day),
    };
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        IconButton(
          onPressed: () => onChanged(offset - 1),
          icon: Icon(
            isRtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: offset == 0 ? null : () => onChanged(0),
            child: Column(
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${offset <= 1 ? '${context.formatWeekdayDate(day)} · ' : ''}${context.formatHijri(hijri)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => onChanged(offset + 1),
          icon: Icon(
            isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
          ),
        ),
      ],
    );
  }
}

class _PrayerList extends StatelessWidget {
  const _PrayerList({
    required this.times,
    required this.isToday,
    required this.settings,
  });

  final PrayerTimes times;
  final bool isToday;
  final PrayerSettings settings;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final current = isToday ? times.currentAt(now) : null;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          for (final prayer in Prayer.values)
            _PrayerRow(
              prayer: prayer,
              time: times.timeOf(prayer),
              date: times.date,
              isCurrent: prayer == current,
              isPast:
                  isToday &&
                  times.timeOf(prayer).isBefore(now) &&
                  prayer != current,
              alert: settings.alertFor(prayer),
            ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.prayer,
    required this.time,
    required this.date,
    required this.isCurrent,
    required this.isPast,
    required this.alert,
  });

  final Prayer prayer;
  final DateTime time;
  final DateTime date;
  final bool isCurrent;
  final bool isPast;
  final PrayerAlert alert;

  static const _cycle = [
    PrayerAlert.sound,
    PrayerAlert.silent,
    PrayerAlert.off,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final fg = isCurrent
        ? colors.primary
        : (isPast ? colors.textMuted : colors.text);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isCurrent ? colors.primary.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            prayerIcon(prayer),
            color: isCurrent ? colors.primary : colors.textMuted,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.prayerName(prayer, on: date),
              style: text.titleMedium?.copyWith(
                color: fg,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            context.formatTime(time),
            style: text.titleMedium?.copyWith(
              color: fg,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            tooltip: l10n.alertName(alert),
            icon: Icon(
              alertIcon(alert),
              size: 20,
              color: alert == PrayerAlert.off
                  ? colors.textMuted.withValues(alpha: 0.6)
                  : colors.accent,
            ),
            onPressed: () {
              final next = _cycle[(_cycle.indexOf(alert) + 1) % _cycle.length];
              context.read<PrayerTimesCubit>().setAlert(prayer, next);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      '${l10n.prayerName(prayer)} · ${l10n.alertName(next)}',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}

/// Explains, and fixes in one tap, why a prayer notification might not arrive.
class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<PrayerTimesCubit>().state;
    final perms = state.permissions;
    final wantsAlerts = state.settings.alerts.values.any(
      (a) => a != PrayerAlert.off,
    );
    if (perms == null || !wantsAlerts) return const SizedBox.shrink();

    final (message, action) = !perms.notificationsAllowed
        ? (
            l10n.notificationsBlocked,
            context.read<PrayerTimesCubit>().requestNotificationPermission,
          )
        : !perms.exactAlarmsAllowed
        ? (
            l10n.exactAlarmsNeeded,
            context.read<PrayerTimesCubit>().requestExactAlarms,
          )
        : (null, null);
    if (message == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AppCard(
        color: colors.accent.withValues(alpha: 0.08),
        child: Row(
          children: [
            Icon(Icons.notifications_off_outlined, color: colors.accent),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(onPressed: action, child: Text(l10n.allow)),
          ],
        ),
      ),
    );
  }
}
