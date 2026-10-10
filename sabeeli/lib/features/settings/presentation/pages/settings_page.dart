import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/numerals.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../quran/presentation/widgets/riwayah_picker.dart';
import '../cubit/settings_cubit.dart';
import '../../../../core/widgets/ambient_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();
    final settings = context.watch<SettingsCubit>().state;

    return AmbientScaffold(
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
            SectionHeader(l10n.general),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (final (icon, label, route) in [
                    (LucideIcons.mapPin, l10n.location, AppRoutes.locationName),
                    (
                      LucideIcons.bellRing,
                      l10n.prayerTimes,
                      AppRoutes.prayerSettingsName,
                    ),
                    (
                      LucideIcons.calendarDays,
                      l10n.hijriCalendar,
                      AppRoutes.hijriName,
                    ),
                    (LucideIcons.info, l10n.about, AppRoutes.aboutName),
                  ])
                    ListTile(
                      leading: Icon(icon),
                      title: Text(label),
                      trailing: Icon(context.forwardChevron, size: 18),
                      onTap: () => context.pushNamed(route),
                    ),
                ],
              ),
            ),
            SectionHeader(l10n.riwayah),
            const AppCard(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: RiwayahPicker(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Text(
                l10n.riwayahNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SectionHeader(l10n.theme),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(LucideIcons.moon),
                  label: Text(l10n.themeDark),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(LucideIcons.sun),
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(LucideIcons.sunMoon),
                  label: Text(l10n.themeSystem),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) => cubit.setThemeMode(s.first),
            ),
            SectionHeader(l10n.language),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: RadioGroup<String>(
                groupValue: settings.languageCode ?? '',
                onChanged: (code) => cubit.setLanguage(
                  code == null || code.isEmpty ? null : code,
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: '',
                      title: Text(l10n.systemLanguage),
                    ),
                    for (final lang in L10n.languages)
                      RadioListTile<String>(
                        value: lang.code,
                        title: Text(lang.nativeName),
                      ),
                  ],
                ),
              ),
            ),
            SectionHeader(l10n.numerals),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: RadioGroup<NumeralStyle>(
                groupValue: settings.numeralStyle,
                onChanged: (style) =>
                    style == null ? null : cubit.setNumeralStyle(style),
                child: Column(
                  children: [
                    for (final (style, label, sample) in [
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
                    ])
                      RadioListTile<NumeralStyle>(
                        value: style,
                        title: Text(label),
                        secondary: Text(
                          sample,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
