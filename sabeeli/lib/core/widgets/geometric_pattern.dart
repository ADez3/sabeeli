import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A lattice of eight-pointed stars (khatam), the most common motif of Islamic
/// geometric art, drawn as thin outlines at low opacity behind hero surfaces.
class GeometricPattern extends StatelessWidget {
  const GeometricPattern({
    super.key,
    required this.color,
    this.cell = 56,
    this.strokeWidth = 1,
  });

  final Color color;
  final double cell;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: CustomPaint(
        painter: _StarLatticePainter(
          color: color,
          cell: cell,
          strokeWidth: strokeWidth,
        ),
        size: Size.infinite,
      ),
    ),
  );
}

class _StarLatticePainter extends CustomPainter {
  _StarLatticePainter({
    required this.color,
    required this.cell,
    required this.strokeWidth,
  });

  final Color color;
  final double cell;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final r = cell * 0.36;
    final star = _star(r);
    final octagon = _octagon(r * 0.42);

    for (var y = -cell; y < size.height + cell; y += cell) {
      for (var x = -cell; x < size.width + cell; x += cell) {
        final shift = ((y / cell).round().isOdd) ? cell / 2 : 0.0;
        canvas.save();
        canvas.translate(x + shift, y);
        canvas.drawPath(star, paint);
        canvas.drawPath(octagon, paint);
        canvas.restore();
      }
    }
  }

  /// Two squares rotated 45° apart, merged into one outline.
  static Path _star(double r) {
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final radius = i.isEven ? r : r * 0.76;
      final angle = i * math.pi / 8 - math.pi / 2;
      final p = Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  static Path _octagon(double r) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 + math.pi / 8;
      final p = Offset(math.cos(angle) * r, math.sin(angle) * r);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_StarLatticePainter old) =>
      old.color != color || old.cell != cell || old.strokeWidth != strokeWidth;
}
