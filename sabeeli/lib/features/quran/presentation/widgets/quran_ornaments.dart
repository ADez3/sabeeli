import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';

/// A number in a thin ring, for surah and juz lists.
class NumberBadge extends StatelessWidget {
  const NumberBadge(this.label, {super.key, this.size = 38});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.outline, width: 1.2),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colors.textMuted,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.32,
        ),
      ),
    );
  }
}

/// The heading that opens each surah in the mushaf: the name between two hairlines
/// that fade out towards the margins.
class SurahBanner extends StatelessWidget {
  const SurahBanner({super.key, required this.nameArabic});

  final String nameArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget rule(bool leading) => Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.accent.withValues(alpha: leading ? 0 : 0.7),
              colors.accent.withValues(alpha: leading ? 0.7 : 0),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          rule(true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'سُورَةُ $nameArabic',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFonts.display,
                fontSize: 24,
                height: 1.3,
                color: colors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          rule(false),
        ],
      ),
    );
  }
}
