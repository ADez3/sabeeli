import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/widgets/ambient_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  /// Attribution the sources' licences ask for (full list in assets/SOURCES.md).
  static const _credits = [
    (
      'King Fahd Glorious Quran Printing Complex',
      'Uthmanic Hafs text & font, Tafsir al-Muyassar',
    ),
    ('Tanzil.net', 'Quran metadata (CC BY 3.0)'),
    ('Saheeh International', 'English translation'),
    ('fawazahmed0/quran-api', 'Translations downloaded on demand'),
    ('Hisn al-Muslim — Sa\'id ibn Wahf al-Qahtani', 'Azkar (hisnmuslim.com)'),
    ('hijridate — Mohammed Alshehri', 'Umm al-Qura calendar table (MIT)'),
    ('OpenStreetMap Nominatim', 'Place names (© OpenStreetMap contributors)'),
    ('IBM Plex Sans Arabic, Amiri', 'Fonts (SIL Open Font License)'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return AmbientScaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                'سبيلي',
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontSize: 48,
                  color: colors.accent,
                ),
              ),
            ),
            Center(child: Text(l10n.appName, style: text.headlineSmall)),
            Center(
              child: Text(
                context.digits(l10n.version('0.1.0')),
                style: text.bodySmall?.copyWith(color: colors.textMuted),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.aboutText,
              textAlign: TextAlign.center,
              style: text.bodyLarge?.copyWith(height: 1.6),
            ),
            SectionHeader(l10n.credits),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (final (title, subtitle) in _credits)
                    ListTile(
                      dense: true,
                      title: Text(title),
                      subtitle: Text(subtitle),
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
