import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final tools = [
      (Icons.explore_rounded, l10n.qibla, AppRoutes.qiblaName, colors.accent),
      (
        Icons.radio_button_checked_rounded,
        l10n.tasbih,
        AppRoutes.tasbihName,
        colors.primary,
      ),
      (
        Icons.calendar_month_rounded,
        l10n.hijriCalendar,
        AppRoutes.hijriName,
        colors.primary,
      ),
    ];
    final settings = [
      (Icons.tune_rounded, l10n.prayerTimes, AppRoutes.prayerSettingsName),
      (Icons.palette_outlined, l10n.settings, AppRoutes.settingsName),
      (Icons.info_outline_rounded, l10n.about, AppRoutes.aboutName),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.more)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                for (final (i, (icon, label, route, tint))
                    in tools.indexed) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppCard(
                      onTap: () => context.pushNamed(route),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xl,
                        horizontal: AppSpacing.sm,
                      ),
                      child: Column(
                        children: [
                          IconBadge(icon, color: tint, size: 52),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SectionHeader(l10n.settings),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (final (icon, label, route) in settings)
                    ListTile(
                      leading: Icon(icon),
                      title: Text(label),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.pushNamed(route),
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
