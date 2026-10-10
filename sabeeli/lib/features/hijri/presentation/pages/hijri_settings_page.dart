import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/hijri/hijri_date.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/hijri_settings.dart';
import '../cubit/hijri_cubit.dart';
import '../widgets/hijri_labels.dart';
import '../widgets/moon_month.dart';
import '../../../../core/widgets/ambient_scaffold.dart';

/// Lets each user follow their own country's announcements: pick the base
/// calendar, shift it, or pin the first day of the current and coming months.
class HijriSettingsPage extends StatelessWidget {
  const HijriSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final cubit = context.read<HijriCubit>();
    final state = context.watch<HijriCubit>().state;
    final settings = state.settings;
    final today = state.today ?? state.calendar.fromGregorian(DateTime.now());

    // This month and the next two: the ones a moon-sighting announcement concerns.
    final months = [for (var i = 0; i < 3; i++) today.monthIndex + i];

    return AmbientScaffold(
      appBar: AppBar(title: Text(l10n.hijriCalendar)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            const SizedBox(height: AppSpacing.md),
            const MoonMonth(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.xs,
              ),
              child: Text(
                l10n.hijriCalendarHint,
                style: text.bodySmall?.copyWith(
                  color: colors.textMuted,
                  height: 1.5,
                ),
              ),
            ),
            SectionHeader(l10n.hijriMethod),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: RadioGroup<HijriMethod>(
                groupValue: settings.method,
                onChanged: (m) => m == null ? null : cubit.setMethod(m),
                child: Column(
                  children: [
                    RadioListTile(
                      value: HijriMethod.ummAlQura,
                      title: Text(l10n.hijriUmmAlQura),
                    ),
                    RadioListTile(
                      value: HijriMethod.tabular,
                      title: Text(l10n.hijriTabular),
                    ),
                  ],
                ),
              ),
            ),
            SectionHeader(l10n.hijriOffset),
            AppCard(
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: settings.dayOffset > -2
                        ? () => cubit.setDayOffset(settings.dayOffset - 1)
                        : null,
                    icon: const Icon(LucideIcons.minus),
                  ),
                  Expanded(
                    child: Text(
                      context.digits(_offsetLabel(l10n, settings.dayOffset)),
                      textAlign: TextAlign.center,
                      style: text.titleMedium,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: settings.dayOffset < 2
                        ? () => cubit.setDayOffset(settings.dayOffset + 1)
                        : null,
                    icon: const Icon(LucideIcons.plus),
                  ),
                ],
              ),
            ),
            SectionHeader(l10n.hijriCorrections),
            for (final index in months) ...[
              _MonthStartCard(monthIndex: index),
              const SizedBox(height: AppSpacing.md),
            ],
            if (settings.monthOverrides.isNotEmpty || settings.dayOffset != 0)
              TextButton.icon(
                onPressed: cubit.resetAll,
                icon: const Icon(LucideIcons.rotateCcw),
                label: Text(l10n.hijriResetAll),
              ),
          ],
        ),
      ),
    );
  }

  static String _offsetLabel(AppLocalizations l10n, int offset) {
    final label = l10n.hijriOffsetValue(offset.abs());
    if (offset > 0) return '+$label';
    if (offset < 0) return '−$label';
    return label;
  }
}

/// "Ramadan began on …" with the computed day and the two days either side.
class _MonthStartCard extends StatelessWidget {
  const _MonthStartCard({required this.monthIndex});
  final int monthIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<HijriCubit>();
    final state = context.watch<HijriCubit>().state;
    final ym = HijriDate.fromMonthIndex(monthIndex);
    final computed = cubit.unpinnedMonthStart(monthIndex);
    final pinned = state.settings.monthOverrides[monthIndex];
    final options = [
      for (var d = -1; d <= 1; d++)
        DateTime(computed.year, computed.month, computed.day + d),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hijriMonthStartedOn(
              '${l10n.hijriMonthName(ym.month)} ${context.digits(ym.year)}',
            ),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: Text(
                  '${l10n.hijriAutomatic} · ${context.formatShortDate(computed)}',
                ),
                selected: pinned == null,
                onSelected: (_) => cubit.setMonthStart(monthIndex, null),
              ),
              for (final d in options)
                if (d != computed)
                  ChoiceChip(
                    label: Text(context.formatShortDate(d)),
                    selected: pinned != null && _sameDay(pinned, d),
                    selectedColor: colors.accent.withValues(alpha: 0.2),
                    onSelected: (_) => cubit.setMonthStart(monthIndex, d),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
