import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/utils/arabic_numerals.dart';
import '../../../../core/utils/numerals.dart';
import '../../../../core/utils/formatters.dart';

/// The end-of-ayah marker in the user's digits.
///
/// With Arabic-Indic digits the Quran font draws its own ornament: a no-break space
/// followed by the number is ligated into the numbered circle. The font has no such
/// ligature for Western or Persian digits, so for those the ornament is painted here.
InlineSpan ayahNumberSpan(
  BuildContext context, {
  required int ayah,
  required TextStyle style,
  Color? color,
  Color? background,
  GestureRecognizer? recognizer,
  VoidCallback? onTap,
}) {
  final numerals = context.numerals;
  if (numerals == Numerals.arabicIndic) {
    return TextSpan(
      text: ' ${toArabicIndic(ayah)} ',
      recognizer: recognizer,
      style: style.copyWith(color: color, backgroundColor: background),
    );
  }
  final size = (style.fontSize ?? 22) * 1.2;
  return TextSpan(
    children: [
      // A no-break space keeps the marker on the line of the ayah's last word.
      TextSpan(
        text: ' ',
        recognizer: recognizer,
        style: style.copyWith(backgroundColor: background),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: background,
            padding: EdgeInsets.symmetric(horizontal: size * 0.12),
            child: AyahOrnament(
              label: numerals.apply('$ayah'),
              size: size,
              color: color ?? style.color ?? Colors.grey,
            ),
          ),
        ),
      ),
      TextSpan(
        text: ' ',
        recognizer: recognizer,
        style: style.copyWith(backgroundColor: background),
      ),
    ],
  );
}

/// A small rosette with the ayah number inside.
class AyahOrnament extends StatelessWidget {
  const AyahOrnament({
    super.key,
    required this.label,
    required this.size,
    required this.color,
  });

  final String label;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _RosettePainter(color),
      child: Center(
        child: Text(
          label,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontFamily: AppFonts.ui,
            fontSize: size * (label.length > 2 ? 0.3 : 0.36),
            fontWeight: FontWeight.w600,
            color: color,
            height: 1,
          ),
        ),
      ),
    ),
  );
}

class _RosettePainter extends CustomPainter {
  _RosettePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;
    canvas.drawCircle(c, r * 0.78, stroke);
    canvas.drawCircle(c, r * 0.66, stroke..strokeWidth = size.width * 0.02);
    final dot = Paint()..color = color;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawCircle(
        c + Offset(math.cos(a), math.sin(a)) * r * 0.9,
        size.width * 0.045,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(_RosettePainter old) => old.color != color;
}
