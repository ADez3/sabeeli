import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/astronomy/solar.dart';
import '../../../../../core/theme/sky.dart';
import '../../../../../core/widgets/moon_phase.dart';

/// Maps a body's hour angle and altitude to a point in the scene: the day's arc
/// runs from the left edge (rising) to the right edge (setting), whatever the
/// hemisphere, and the horizon is [horizonY].
Offset skyPoint(Size size, double horizonY, SkyPosition p) {
  final x = size.width / 2 + p.hourAngle / 105 * (size.width / 2);
  final y =
      horizonY -
      (p.altitude / 70).clamp(-1.0, 1.0) * (horizonY - size.height * 0.08);
  return Offset(x, y);
}

/// The sky: gradient, stars, the moon in its phase and the sun with its glow.
class SkyPainter extends CustomPainter {
  SkyPainter({
    required this.colors,
    required this.sun,
    required this.moon,
    required this.moonAge,
    required this.horizonFraction,
    required this.clock,
    required this.animate,
  }) : super(repaint: clock);

  final SkyColors colors;
  final SkyPosition sun;
  final SkyPosition moon;
  final double moonAge;
  final double horizonFraction;

  /// Seconds elapsed, for twinkling and shooting stars.
  final ValueNotifier<double> clock;
  final bool animate;

  static final _stars = _generateStars();

  static List<(Offset, double, double, double)> _generateStars() {
    final r = math.Random(42);
    return [
      for (var i = 0; i < 150; i++)
        (
          Offset(r.nextDouble(), math.pow(r.nextDouble(), 1.4).toDouble()),
          0.4 + r.nextDouble() * 1.2, // radius
          0.35 + r.nextDouble() * 0.65, // brightness
          r.nextDouble() * math.pi * 2, // twinkle phase
        ),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final horizonY = size.height * horizonFraction;
    final t = animate ? clock.value : 0.0;

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors.gradient,
          stops: [0, 0.55 * horizonFraction, horizonFraction],
        ).createShader(Offset.zero & size),
    );

    final starAlpha = SkyPalette.starOpacity(sun.altitude);
    if (starAlpha > 0) _paintStars(canvas, size, horizonY, starAlpha, t);
    _paintMoon(canvas, size, horizonY);
    _paintSun(canvas, size, horizonY);

    // A band of light along the horizon, warmest when the sun is close to it.
    final glow = (1 - (sun.altitude.abs() / 18)).clamp(0.0, 1.0);
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        horizonY - size.height * 0.18,
        size.width,
        size.height * 0.2,
      ),
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.horizon.withValues(alpha: 0),
                colors.horizon.withValues(alpha: 0.35 + glow * 0.4),
              ],
            ).createShader(
              Rect.fromLTWH(
                0,
                horizonY - size.height * 0.18,
                size.width,
                size.height * 0.2,
              ),
            ),
    );
  }

  void _paintStars(
    Canvas canvas,
    Size size,
    double horizonY,
    double alpha,
    double t,
  ) {
    final paint = Paint();
    for (final (pos, radius, brightness, phase) in _stars) {
      final o = Offset(pos.dx * size.width, pos.dy * horizonY * 0.95);
      final twinkle = 0.7 + 0.3 * math.sin(t * (0.6 + brightness) + phase);
      paint.color = Colors.white.withValues(
        alpha: alpha * brightness * twinkle,
      );
      canvas.drawCircle(o, radius, paint);
    }

    // Now and then a shooting star crosses a dark sky.
    if (alpha > 0.6 && animate) {
      const period = 13.0;
      final cycle = (t / period).floor();
      final p = (t - cycle * period) / 0.9;
      if (p >= 0 && p <= 1) {
        final r = math.Random(cycle);
        final start = Offset(
          size.width * (0.15 + r.nextDouble() * 0.6),
          horizonY * (0.08 + r.nextDouble() * 0.3),
        );
        final dir = Offset(r.nextBool() ? 1 : -1, 0.45) * size.width * 0.35;
        final head = start + dir * p;
        final tail = start + dir * math.max(0, p - 0.25);
        canvas.drawLine(
          tail,
          head,
          Paint()
            ..shader = LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.9 * (1 - p)),
              ],
            ).createShader(Rect.fromPoints(tail, head))
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  void _paintSun(Canvas canvas, Size size, double horizonY) {
    if (sun.altitude < -6) return;
    final c = skyPoint(size, horizonY, sun);
    final low = (1 - (sun.altitude / 25)).clamp(0.0, 1.0);
    final glowColor = Color.lerp(
      const Color(0xFFFFF0C8),
      const Color(0xFFFF9A55),
      low,
    )!;
    final radius = size.width * 0.32;
    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            glowColor.withValues(alpha: 0.55),
            glowColor.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: radius)),
    );
    canvas.drawCircle(
      c,
      15,
      Paint()
        ..color = Color.lerp(
          const Color(0xFFFFFBEF),
          const Color(0xFFFFD49A),
          low,
        )!,
    );
  }

  void _paintMoon(Canvas canvas, Size size, double horizonY) {
    // Within about a day of the new moon it cannot be seen at all.
    if (moon.altitude < -2 || moonAge < 1.2 || moonAge > 28.3) return;
    final c = skyPoint(size, horizonY, moon);
    // Pale by day, bright at night.
    final night = SkyPalette.starOpacity(sun.altitude);
    final alpha = 0.45 + 0.55 * night;
    const r = 13.0;

    canvas.drawCircle(
      c,
      r * 4,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.18 * night),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: r * 4)),
    );
    // Earthshine: the unlit disc is faintly visible.
    canvas.drawCircle(
      c,
      r,
      Paint()..color = Colors.white.withValues(alpha: 0.06 * alpha),
    );

    paintMoonPhase(
      canvas,
      c,
      r,
      moonAge,
      const Color(0xFFF5F1E4).withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(SkyPainter old) =>
      old.colors != colors ||
      old.sun.altitude != sun.altitude ||
      old.sun.hourAngle != sun.hourAngle ||
      old.moonAge != moonAge ||
      old.animate != animate;
}
