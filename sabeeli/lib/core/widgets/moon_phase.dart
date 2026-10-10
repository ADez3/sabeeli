import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints the lit part of the moon for an [age] in days since the new moon
/// (0…29.53): a growing crescent on the right, full at ~14.8, then waning on the
/// left (as seen from the northern hemisphere).
void paintMoonPhase(
  Canvas canvas,
  Offset center,
  double radius,
  double age,
  Color lit,
) {
  final phase = age / 29.530588853;
  final k = math.cos(phase * 2 * math.pi); // 1 new, −1 full
  final path = Path()
    ..moveTo(0, -radius)
    ..arcTo(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      -math.pi / 2,
      math.pi,
      false,
    )
    ..arcTo(
      Rect.fromCenter(
        center: Offset.zero,
        width: 2 * radius * k.abs(),
        height: 2 * radius,
      ),
      math.pi / 2,
      k > 0 ? -math.pi : math.pi,
      false,
    )
    ..close();
  canvas.save();
  canvas.translate(center.dx, center.dy);
  if (phase >= 0.5) canvas.scale(-1, 1);
  canvas.drawPath(path, Paint()..color = lit);
  canvas.restore();
}

/// A small moon in its phase, with the unlit disc faintly visible.
class MoonPhaseIcon extends StatelessWidget {
  const MoonPhaseIcon({
    super.key,
    required this.age,
    this.size = 22,
    this.lit = const Color(0xFFF5F1E4),
    this.dark = const Color(0x22FFFFFF),
  });

  final double age;
  final double size;
  final Color lit;
  final Color dark;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _MoonPainter(age, lit, dark)),
  );
}

class _MoonPainter extends CustomPainter {
  _MoonPainter(this.age, this.lit, this.dark);

  final double age;
  final Color lit;
  final Color dark;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.drawCircle(c, r, Paint()..color = dark);
    paintMoonPhase(canvas, c, r, age, lit);
  }

  @override
  bool shouldRepaint(_MoonPainter old) =>
      old.age != age || old.lit != lit || old.dark != dark;
}
