import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ambient_scaffold.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/hijri/fasting.dart';
import '../../domain/entities/prayer_settings.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/prayer_labels.dart';

/// Optional daily reminders for the adhkar and the Quran, each at its own time.
/// Off by default, and introduced honestly: a daily notification helps some
/// people and wears others out.
class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  /// The time a reminder starts at when first turned on.
  static const _defaults = {
    DailyReminder.morningAzkar: 7 * 60,
    DailyReminder.eveningAzkar: 17 * 60 + 30,
    DailyReminder.sleepAzkar: 22 * 60,
    DailyReminder.quran: 20 * 60 + 30,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final reminders = context.select(
      (PrayerTimesCubit c) => c.state.settings.dailyReminders,
    );
    return AmbientScaffold(
      appBar: AppBar(title: Text(l10n.dailyReminders)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                l10n.dailyRemindersIntro,
                style: text.bodyMedium?.copyWith(
                  color: colors.textMuted,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final kind in DailyReminder.values) ...[
              _ReminderCard(
                kind: kind,
                minutes: reminders[kind],
                onChanged: (m) =>
                    context.read<PrayerTimesCubit>().setDailyReminder(kind, m),
                defaultMinutes: _defaults[kind]!,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Text(l10n.fastingReminders, style: text.titleMedium),
            ),
            const _SuhoorCard(),
            const SizedBox(height: AppSpacing.md),
            const _FastCard(),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.kind,
    required this.minutes,
    required this.onChanged,
    required this.defaultMinutes,
  });

  final DailyReminder kind;

  /// Null when off.
  final int? minutes;
  final ValueChanged<int?> onChanged;
  final int defaultMinutes;

  Widget _icon(Color color) => switch (kind) {
    DailyReminder.morningAzkar => Icon(LucideIcons.sunrise, color: color),
    DailyReminder.eveningAzkar => Icon(LucideIcons.sunset, color: color),
    DailyReminder.sleepAzkar => Icon(LucideIcons.moonStar, color: color),
    DailyReminder.quran => Icon(LucideIcons.bookOpen, color: color),
  };

  Future<void> _pickTime(BuildContext context) async {
    final current = minutes ?? defaultMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked != null) onChanged(picked.hour * 60 + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final on = minutes != null;
    final m = minutes ?? defaultMinutes;
    final time = DateTime(2000, 1, 1, m ~/ 60, m % 60);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: on ? 1 : 0.75,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: on ? colors.primary.withValues(alpha: 0.4) : colors.hairline,
          ),
        ),
        child: Row(
          children: [
            kind == DailyReminder.quran
                ? _icon(colors.primary)
                : kind == DailyReminder.sleepAzkar
                ? _icon(colors.secondary)
                : _icon(colors.accent),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.dailyReminderName(kind), style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(l10n.dailyReminderBody(kind), style: text.bodySmall),
                  const SizedBox(height: AppSpacing.sm),
                  // The time, tappable even while off: pick it, then turn on.
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _pickTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: colors.text.withValues(alpha: 0.06),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 14,
                            color: colors.textMuted,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            context.formatTime(time),
                            style: text.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: on, onChanged: (v) => onChanged(v ? m : null)),
          ],
        ),
      ),
    );
  }
}

/// A reminder card's frame: icon, title, line, switch, and what opens when on.
class _Frame extends StatelessWidget {
  const _Frame({
    required this.icon,
    required this.title,
    required this.body,
    required this.on,
    required this.onChanged,
    this.extra,
  });

  final Widget icon;
  final String title;
  final String body;
  final bool on;
  final ValueChanged<bool> onChanged;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: on ? colors.primary.withValues(alpha: 0.4) : colors.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(body, style: text.bodySmall),
                  ],
                ),
              ),
              Switch(value: on, onChanged: onChanged),
            ],
          ),
          if (on && extra != null) ...[
            const SizedBox(height: AppSpacing.md),
            extra!,
          ],
        ],
      ),
    );
  }
}

class _SuhoorCard extends StatelessWidget {
  const _SuhoorCard();

  static const _choices = [30, 45, 60];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<PrayerTimesCubit>();
    final minutes = context.select(
      (PrayerTimesCubit c) => c.state.settings.suhoorMinutes,
    );
    return _Frame(
      icon: Icon(LucideIcons.moonStar, color: colors.accent),
      title: l10n.suhoorReminderTitle,
      body: l10n.suhoorReminderBody,
      on: minutes != null,
      onChanged: (v) => cubit.setSuhoorReminder(v ? 45 : null),
      extra: Wrap(
        spacing: AppSpacing.sm,
        children: [
          for (final m in _choices)
            ChoiceChip(
              label: Text(context.digits(l10n.minutesBefore(m))),
              selected: minutes == m,
              onSelected: (_) => cubit.setSuhoorReminder(m),
            ),
        ],
      ),
    );
  }
}

class _FastCard extends StatelessWidget {
  const _FastCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final cubit = context.read<PrayerTimesCubit>();
    final settings = context.select((PrayerTimesCubit c) => c.state.settings);
    final minutes = settings.fastReminderMinutes;
    final m = minutes ?? 21 * 60;
    final time = DateTime(2000, 1, 1, m ~/ 60, m % 60);
    return _Frame(
      icon: Icon(LucideIcons.calendarHeart, color: colors.primary),
      title: l10n.fastReminderTitle,
      body: l10n.fastReminderBody,
      on: minutes != null,
      onChanged: (v) => cubit.setFastReminder(v ? m : null),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: m ~/ 60, minute: m % 60),
              );
              if (picked != null) {
                cubit.setFastReminder(picked.hour * 60 + picked.minute);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: colors.text.withValues(alpha: 0.06),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.clock, size: 14, color: colors.textMuted),
                  const SizedBox(width: AppSpacing.xs),
                  Text(context.formatTime(time), style: text.labelLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final k in Fasting.voluntary)
                FilterChip(
                  label: Text(l10n.fastName(k)),
                  selected: settings.fastKinds.contains(k),
                  onSelected: (on) {
                    final kinds = {...settings.fastKinds};
                    on ? kinds.add(k) : kinds.remove(k);
                    if (kinds.isNotEmpty) {
                      cubit.setFastReminder(m, kinds: kinds);
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
