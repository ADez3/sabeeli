import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/numerals.dart';
import '../../../../core/widgets/ambient_scaffold.dart';
import '../../../../core/widgets/pill_tabs.dart';
import '../../../../l10n/l10n.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/presentation/widgets/prayer_labels.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/widgets/riwayah_picker.dart';
import '../../../feedback/presentation/widgets/shake_to_report.dart';
import '../cubit/settings_cubit.dart';

/// Settings in a few calm groups. Each row shows its current value; choices
/// open in a sheet rather than spreading long lists over the page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final place = context.select((LocationCubit c) => c.state.location?.name);
    final method = context.select(
      (PrayerTimesCubit c) => c.state.settings.calculation.method,
    );
    final quran = context.watch<QuranCubit>();
    final daily = context.select(
      (PrayerTimesCubit c) => c.state.settings.dailyReminders.length,
    );
    final languageName = settings.languageCode == null
        ? l10n.systemLanguage
        : L10n.languages
              .firstWhere(
                (l) => l.code == settings.languageCode,
                orElse: () => L10n.languages[1],
              )
              .nativeName;

    return AmbientScaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            _Group(
              title: l10n.prayerTimes,
              rows: [
                _Row(
                  icon: LucideIcons.mapPin,
                  title: l10n.location,
                  value: place,
                  onTap: () => context.pushNamed(AppRoutes.locationName),
                ),
                _Row(
                  icon: LucideIcons.bellRing,
                  title: l10n.calculationMethod,
                  value: l10n.methodName(method),
                  onTap: () => context.pushNamed(AppRoutes.prayerSettingsName),
                ),
                _Row(
                  icon: LucideIcons.alarmClock,
                  title: l10n.dailyReminders,
                  value: daily == 0
                      ? l10n.dailyRemindersOff
                      : context.digits(l10n.dailyRemindersOn(daily)),
                  onTap: () => context.pushNamed(AppRoutes.remindersName),
                ),
                _Row(
                  icon: LucideIcons.calendarDays,
                  title: l10n.hijriCalendar,
                  onTap: () => context.pushNamed(AppRoutes.hijriName),
                ),
              ],
            ),
            _Group(
              title: l10n.navQuran,
              rows: [
                _Row(
                  icon: LucideIcons.bookOpen,
                  title: l10n.riwayah,
                  value: l10n.riwayahName(quran.riwayah),
                  onTap: () => _sheet(
                    context,
                    title: l10n.riwayah,
                    child: BlocProvider.value(
                      value: quran,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const RiwayahPicker(),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Text(
                              l10n.riwayahNote,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _Group(
              title: l10n.appearance,
              rows: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: PillTabs(
                    labels: [l10n.themeDark, l10n.themeLight, l10n.themeSystem],
                    selected: switch (settings.themeMode) {
                      ThemeMode.dark => 0,
                      ThemeMode.light => 1,
                      ThemeMode.system => 2,
                    },
                    onChanged: (i) => cubit.setThemeMode(
                      const [
                        ThemeMode.dark,
                        ThemeMode.light,
                        ThemeMode.system,
                      ][i],
                    ),
                  ),
                ),
                _Row(
                  icon: LucideIcons.languages,
                  title: l10n.language,
                  value: languageName,
                  onTap: () => _sheet(
                    context,
                    title: l10n.language,
                    child: _Choices<String?>(
                      selected: settings.languageCode,
                      options: [
                        (null, l10n.systemLanguage, null),
                        for (final lang in L10n.languages)
                          (lang.code, lang.nativeName, null),
                      ],
                      onSelected: cubit.setLanguage,
                    ),
                  ),
                ),
                _Row(
                  icon: LucideIcons.hash,
                  title: l10n.numerals,
                  value: context.digits('123'),
                  onTap: () => _sheet(
                    context,
                    title: l10n.numerals,
                    child: _Choices<NumeralStyle>(
                      selected: settings.numeralStyle,
                      options: [
                        (
                          NumeralStyle.auto,
                          l10n.numeralsAuto,
                          context.digits('123'),
                        ),
                        (
                          NumeralStyle.western,
                          l10n.numeralsWestern,
                          Numerals.western.apply('123'),
                        ),
                        (
                          NumeralStyle.arabicIndic,
                          l10n.numeralsArabic,
                          Numerals.arabicIndic.apply('123'),
                        ),
                        (
                          NumeralStyle.persian,
                          l10n.numeralsPersian,
                          Numerals.persian.apply('123'),
                        ),
                      ],
                      onSelected: cubit.setNumeralStyle,
                    ),
                  ),
                ),
              ],
            ),
            _Group(
              title: l10n.betaBadge,
              rows: [
                SwitchListTile(
                  secondary: Icon(
                    LucideIcons.vibrate,
                    color: context.colors.primary,
                    size: 20,
                  ),
                  title: Text(l10n.shakeToReport),
                  value: settings.shakeToReport,
                  onChanged: cubit.setShakeToReport,
                ),
                _Row(
                  icon: LucideIcons.messageSquareWarning,
                  title: l10n.reportTitle,
                  onTap: () => ShakeToReport.open(context),
                ),
              ],
            ),
            _Group(
              rows: [
                _Row(
                  icon: LucideIcons.info,
                  title: l10n.about,
                  onTap: () => context.pushNamed(AppRoutes.aboutName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _sheet(
    BuildContext context, {
    required String title,
    required Widget child,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheet) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Text(title, style: Theme.of(sheet).textTheme.titleLarge),
            ),
            child,
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    ),
  );
}

/// A titled card of rows separated by hairlines.
class _Group extends StatelessWidget {
  const _Group({this.title, required this.rows});

  final String? title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: colors.textMuted),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceHigh,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: colors.hairline),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  children: [
                    for (final (i, row) in rows.indexed) ...[
                      if (i > 0)
                        Divider(height: 1, indent: 56, color: colors.hairline),
                      row,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(width: AppSpacing.lg),
            Text(title, style: text.bodyLarge),
            const SizedBox(width: AppSpacing.md),
            // The value takes the rest of the row, so every chevron lines up.
            Expanded(
              child: Text(
                value ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: text.bodyMedium?.copyWith(color: colors.textMuted),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(context.forwardChevron, size: 18, color: colors.textFaint),
          ],
        ),
      ),
    );
  }
}

/// A short list of choices for a sheet; picking one closes it.
class _Choices<T> extends StatelessWidget {
  const _Choices({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final T selected;
  final List<(T, String, String?)> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (value, label, trailing) in options)
          ListTile(
            title: Text(label),
            leading: Icon(
              value == selected ? LucideIcons.circleCheck : LucideIcons.circle,
              color: value == selected ? colors.primary : colors.textFaint,
            ),
            trailing: trailing == null
                ? null
                : Text(
                    trailing,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
            onTap: () {
              onSelected(value);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
