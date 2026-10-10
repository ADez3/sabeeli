import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/theme/sky.dart';

/// One layer of the land: dunes rolling along the horizon. Layer 0 is the farthest
/// (palest, flattest); layer 2 is the nearest. A mosque stands on the middle one.
///
/// Colours come from the sky, so the land always belongs to the hour: hazy and
/// warm at sunset, near black at night.
class LandscapePainter extends CustomPainter {
  LandscapePainter({
    required this.layer,
    required this.colors,
    required this.horizonFraction,
  });

  final int layer;
  final SkyColors colors;
  final double horizonFraction;

  static const _ink = Color(0xFF04050B);

  Color get _color => switch (layer) {
    0 => Color.lerp(colors.horizon, _ink, 0.58)!,
    1 => Color.lerp(colors.middle, _ink, 0.76)!,
    _ => Color.lerp(colors.top, _ink, 0.86)!,
  };

  double _height(double x, double w, double base) {
    final (a1, f1, p1, a2, f2, p2) = switch (layer) {
      0 => (7.0, 2.1, 0.4, 4.0, 5.3, 1.9),
      1 => (13.0, 1.4, 2.2, 6.0, 3.7, 0.3),
      _ => (20.0, 0.9, 4.1, 8.0, 2.6, 2.8),
    };
    final u = x / w * math.pi * 2;
    return base - a1 * math.sin(u * f1 + p1) - a2 * math.sin(u * f2 + p2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final horizonY = size.height * horizonFraction;
    final base = horizonY + [4.0, 26.0, 70.0][layer];

    final path = Path()..moveTo(0, size.height);
    for (var x = 0.0; x <= w; x += 4) {
      path.lineTo(x, _height(x, w, base));
    }
    path
      ..lineTo(w, size.height)
      ..close();

    final paint = Paint()..color = _color;
    if (layer == 1) {
      // The mosque sits on the crest of the middle dune, a third from the end.
      final x = w * 0.7;
      canvas.drawPath(
        _mosque(Offset(x, _height(x, w, base) + 4), w * 0.16),
        paint,
      );
    }
    canvas.drawPath(path, paint);

    if (layer == 2) {
      // Fade the nearest dune into the page so cards over it stay legible.
      final rect = Rect.fromLTWH(0, base - 30, w, size.height - base + 30);
      canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_ink.withValues(alpha: 0), _ink.withValues(alpha: 0.85)],
            stops: const [0.25, 1],
          ).createShader(rect),
      );
    }
  }

  /// A quiet silhouette: a domed prayer hall between two minarets. [width] is the
  /// width of the hall; [ground] is the middle of its base.
  static Path _mosque(Offset ground, double width) {
    final hallH = width * 0.34;
    final left = ground.dx - width / 2;
    final top = ground.dy - hallH;
    final dome = width * 0.27;
    final path = Path()..addRect(Rect.fromLTWH(left, top, width, hallH + 6));

    // Onion-shaped dome with a finial.
    final cx = ground.dx;
    path
      ..moveTo(cx - dome, top)
      ..cubicTo(
        cx - dome * 1.1,
        top - dome * 0.9,
        cx - dome * 0.25,
        top - dome * 1.25,
        cx,
        top - dome * 1.55,
      )
      ..cubicTo(
        cx + dome * 0.25,
        top - dome * 1.25,
        cx + dome * 1.1,
        top - dome * 0.9,
        cx + dome,
        top,
      )
      ..close()
      ..addRect(
        Rect.fromCenter(
          center: Offset(cx, top - dome * 1.68),
          width: 1.6,
          height: dome * 0.35,
        ),
      );

    // Two slender minarets with balconies and pointed caps.
    for (final mx in [left - width * 0.08, left + width * 1.08]) {
      final mw = width * 0.07;
      final mh = hallH * 2.6;
      final mTop = ground.dy - mh;
      path
        ..addRect(Rect.fromLTWH(mx - mw / 2, mTop, mw, mh + 6))
        ..addRect(
          Rect.fromLTWH(mx - mw * 0.85, mTop + mh * 0.28, mw * 1.7, mw * 0.5),
        )
        ..moveTo(mx - mw * 0.6, mTop)
        ..lineTo(mx, mTop - mw * 2.4)
        ..lineTo(mx + mw * 0.6, mTop)
        ..close();
    }
    return path;
  }

  @override
  bool shouldRepaint(LandscapePainter old) =>
      old.colors != colors ||
      old.layer != layer ||
      old.horizonFraction != horizonFraction;
}
