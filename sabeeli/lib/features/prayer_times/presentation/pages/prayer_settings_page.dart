import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/astronomy/calculation_method.dart';
import '../../../../core/astronomy/prayer.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/prayer_settings.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/prayer_labels.dart';

class PrayerSettingsPage extends StatelessWidget {
  const PrayerSettingsPage({super.key});

  static const _reminderOptions = [0, 5, 10, 15, 20, 30];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<PrayerTimesCubit>();
    final settings = context.watch<PrayerTimesCubit>().state.settings;
    final calc = settings.calculation;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            SectionHeader(l10n.calculation),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.public_rounded),
                    title: Text(l10n.calculationMethod),
                    subtitle: Text(
                      l10n.methodName(calc.method),
                      style: TextStyle(color: colors.primary),
                    ),
                    onTap: () => _pickMethod(context, calc.method),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wb_sunny_outlined),
                    title: Text(l10n.asrMethod),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: SegmentedButton<AsrMadhab>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: AsrMadhab.standard,
                            label: Text(l10n.asrStandard.split(' (').first),
                          ),
                          ButtonSegment(
                            value: AsrMadhab.hanafi,
                            label: Text(l10n.asrHanafi),
                          ),
                        ],
                        selected: {calc.madhab},
                        onSelectionChanged: (s) => cubit.updateSettings(
                          settings.copyWith(
                            calculation: calc.copyWith(madhab: s.first),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.public_off_outlined),
                    title: Text(l10n.highLatitudeRule),
                    subtitle: Text(
                      l10n.highLatitudeName(calc.highLatitudeRule),
                      style: TextStyle(color: colors.primary),
                    ),
                    onTap: () =>
                        _pickHighLatitude(context, calc.highLatitudeRule),
                  ),
                ],
              ),
            ),
            SectionHeader(l10n.notifications),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (final prayer in Prayer.values)
                    ListTile(
                      leading: Icon(prayerIcon(prayer)),
                      title: Text(l10n.prayerName(prayer)),
                      trailing: DropdownButton<PrayerAlert>(
                        value: settings.alertFor(prayer),
                        underline: const SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        items: [
                          for (final a in PrayerAlert.values)
                            DropdownMenuItem(
                              value: a,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(alertIcon(a), size: 18),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(l10n.alertName(a)),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (a) =>
                            a == null ? null : cubit.setAlert(prayer, a),
                      ),
                    ),
                  const Divider(
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
                  ListTile(
                    leading: const Icon(Icons.alarm_rounded),
                    title: Text(l10n.reminderBefore),
                    trailing: DropdownButton<int>(
                      value: settings.reminderMinutes,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      items: [
                        for (final m in _reminderOptions)
                          DropdownMenuItem(
                            value: m,
                            child: Text(
                              m == 0
                                  ? l10n.reminderOff
                                  : context.digits(l10n.minutesBefore(m)),
                            ),
                          ),
                      ],
                      onChanged: (m) => m == null
                          ? null
                          : cubit.updateSettings(
                              settings.copyWith(reminderMinutes: m),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(l10n.adjustments),
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.md,
                left: AppSpacing.xs,
                right: AppSpacing.xs,
              ),
              child: Text(
                l10n.adjustmentsHint,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.textMuted),
              ),
            ),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (final prayer in Prayer.values)
                    _AdjustmentRow(
                      label: l10n.prayerName(prayer),
                      value: calc.userAdjustments[prayer] ?? 0,
                      onChanged: (v) => cubit.updateSettings(
                        settings.copyWith(
                          calculation: calc.copyWith(
                            userAdjustments: {
                              ...calc.userAdjustments,
                              prayer: v,
                            },
                          ),
                        ),
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

  void _pickMethod(BuildContext context, CalculationMethod current) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        builder: (_, controller) => RadioGroup<CalculationMethod>(
          groupValue: current,
          onChanged: (m) {
            if (m != null) context.read<PrayerTimesCubit>().setMethod(m);
            Navigator.pop(sheetContext);
          },
          child: ListView(
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.md,
                ),
                child: Text(
                  l10n.calculationMethod,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final m in CalculationMethod.values)
                RadioListTile<CalculationMethod>(
                  value: m,
                  title: Text(l10n.methodName(m)),
                  subtitle: Text(
                    context.digits(
                      '${l10n.prayerFajr} ${m.fajrAngle}° · ${l10n.prayerIsha} '
                      '${m.ishaMinutes != null ? l10n.minutesShort(m.ishaMinutes!) : '${m.ishaAngle}°'}',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickHighLatitude(BuildContext context, HighLatitudeRule current) {
    final l10n = context.l10n;
    final cubit = context.read<PrayerTimesCubit>();
    final settings = cubit.state.settings;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => RadioGroup<HighLatitudeRule>(
        groupValue: current,
        onChanged: (r) {
          if (r != null) {
            cubit.updateSettings(
              settings.copyWith(
                calculation: settings.calculation.copyWith(highLatitudeRule: r),
              ),
            );
          }
          Navigator.pop(sheetContext);
        },
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final r in HighLatitudeRule.values)
                RadioListTile<HighLatitudeRule>(
                  value: r,
                  title: Text(l10n.highLatitudeName(r)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdjustmentRow extends StatelessWidget {
  const _AdjustmentRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        end: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          IconButton(
            onPressed: value > -30 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
          SizedBox(
            width: 64,
            child: Text(
              value == 0
                  ? context.digits(0)
                  : '${value > 0 ? '+' : '−'}${context.digits(context.l10n.minutesShort(value.abs()))}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: value == 0 ? colors.textMuted : colors.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          IconButton(
            onPressed: value < 30 ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}
