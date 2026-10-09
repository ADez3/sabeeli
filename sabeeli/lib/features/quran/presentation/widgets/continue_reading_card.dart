import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/quran_cubit.dart';
import 'surah_labels.dart';
import '../../../../core/theme/app_icons.dart';

/// Where the reader stopped, one tap from resuming. Shown on Home and the Quran tab.
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<QuranCubit>().state;
    final data = state.data;
    final position = state.position;

    final title = position == null ? l10n.startReading : l10n.continueReading;
    final surah = data?.surah(position?.ref.surah ?? 1);
    final subtitle = position == null || surah == null
        ? null
        : '${context.digits(l10n.surahAyah(context.surahName(surah), position.ref.ayah))} · ${context.digits(l10n.pageNumber(position.page))}';

    return AppCard(
      onTap: () => context.pushNamed(
        AppRoutes.quranPageName,
        pathParameters: {'page': '${position?.page ?? 1}'},
      ),
      child: Row(
        children: [
          const IconBadge(LucideIcons.bookOpenText),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: text.bodySmall?.copyWith(color: colors.textMuted),
                  ),
              ],
            ),
          ),
          if (surah != null)
            Text(
              surah.nameArabic,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFonts.display,
                fontSize: 20,
                color: colors.accent,
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          Icon(context.forwardArrow, color: colors.textMuted, size: 20),
        ],
      ),
    );
  }
}
