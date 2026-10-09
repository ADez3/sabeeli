import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/geometric_pattern.dart';

/// A number inside an eight-pointed star, for surah and juz lists.
class StarNumber extends StatelessWidget {
  const StarNumber(this.label, {super.key, this.size = 42});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _StarPainter(color: colors.accent),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w600,
              fontSize: size * 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 1;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final rotation in [0.0, math.pi / 4]) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = rotation + i * math.pi / 2 + math.pi / 4;
        final p = c + Offset(math.cos(a), math.sin(a)) * r;
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path..close(), paint);
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}

/// The framed band that opens each surah in the mushaf.
class SurahBanner extends StatelessWidget {
  const SurahBanner({super.key, required this.nameArabic, this.subtitle});

  final String nameArabic;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: colors.accent.withValues(alpha: 0.6),
          width: 1.2,
        ),
        gradient: LinearGradient(
          colors: [
            colors.accent.withValues(alpha: 0.04),
            colors.accent.withValues(alpha: 0.14),
            colors.accent.withValues(alpha: 0.04),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: GeometricPattern(
                color: colors.accent.withValues(alpha: 0.08),
                cell: 32,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'سُورَةُ $nameArabic',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: AppFonts.display,
                    fontSize: 24,
                    height: 1.3,
                    color: colors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: colors.textMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
