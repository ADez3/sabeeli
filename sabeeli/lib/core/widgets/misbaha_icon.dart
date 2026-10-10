import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A misbaha drawn on Lucide's 24-unit grid, so it sits among Lucide icons: a
/// ring of beads closed by the imam bead, with its tassel. Lucide has no prayer
/// beads, and a generic sparkle says nothing about dhikr.
class MisbahaIcon extends StatelessWidget {
  const MisbahaIcon({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _MisbahaIconPainter(color ?? IconTheme.of(context).color!),
    ),
  );
}

class _MisbahaIconPainter extends CustomPainter {
  const _MisbahaIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final fill = Paint()..color = color;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    const centre = Offset(12, 9.4);
    const ring = 7.2;
    // Eleven beads, leaving the bottom of the ring to the imam bead.
    const beads = 11;
    for (var i = 0; i < beads; i++) {
      final a = math.pi / 2 + (i + 1) * 2 * math.pi / (beads + 1);
      canvas.drawCircle(centre + Offset.fromDirection(a, ring), 1.75, fill);
    }
    // The imam bead, elongated, then the tassel.
    final imam = centre + const Offset(0, ring);
    canvas.drawLine(imam.translate(0, -1.2), imam.translate(0, 1.6), stroke);
    final knot = imam.translate(0, 3);
    canvas.drawLine(imam.translate(0, 1.6), knot, stroke);
    canvas.drawLine(knot, knot.translate(-2.2, 2.8), stroke);
    canvas.drawLine(knot, knot.translate(2.2, 2.8), stroke);
  }

  @override
  bool shouldRepaint(_MisbahaIconPainter old) => old.color != color;
}
