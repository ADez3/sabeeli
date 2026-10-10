import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../domain/entities/quran_entities.dart';

/// Geometry of the Quran sky: the 114 surahs on a golden-angle spiral, in mushaf
/// order, from Al-Fatihah at the centre to An-Nas at the rim.
abstract final class QuranSkyGeometry {
  static const size = 1000.0;
  static const center = Offset(size / 2, size / 2);

  static final List<Offset> positions = [
    for (var i = 0; i < 114; i++)
      center + Offset.fromDirection(i * 2.39996323, 36 * math.sqrt(i + 0.6)),
  ];

  /// Longer surahs are bigger stars (Al-Baqarah, 286 ayahs, is the largest).
  static double radius(SurahInfo s) => 2.6 + 7 * math.sqrt(s.ayahCount / 286);

  /// Meccan surahs burn warm, Medinan ones cool.
  static Color tint(SurahInfo s) => s.revelation == Revelation.meccan
      ? const Color(0xFFFFE2B0)
      : const Color(0xFFBFD0FF);

  /// The surah under [p] (scene coordinates), within [slop] scene units.
  static int? hit(Offset p, QuranData data, double slop) {
    int? best;
    var bestD = double.infinity;
    for (var i = 0; i < 114; i++) {
      final d = (positions[i] - p).distance - radius(data.surahs[i]);
      if (d < slop && d < bestD) {
        bestD = d;
        best = i + 1;
      }
    }
    return best;
  }
}

/// The still part of the sky, painted once: deep space, a faint milky band, dust,
/// and the thin path that joins the surahs in reading order.
class QuranSkyBackdropPainter extends CustomPainter {
  const QuranSkyBackdropPainter({this.showPath = true});

  /// The path joining the surahs, meaningful only behind the star map.
  final bool showPath;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF181C44), Color(0xFF0A0C22), Color(0xFF04050D)],
          stops: [0, 0.45, 1],
        ).createShader(rect),
    );

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.45);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 1.3,
        height: size.height * 0.22,
      ),
      Paint()
        ..color = const Color(0x12B9C6FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60),
    );
    canvas.restore();

    final r = math.Random(3);
    final dust = Paint();
    for (var i = 0; i < 420; i++) {
      dust.color = Colors.white.withValues(alpha: 0.08 + r.nextDouble() * 0.3);
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        0.3 + r.nextDouble() * 0.7,
        dust,
      );
    }
    if (!showPath) return;

    final path = Path()
      ..moveTo(
        QuranSkyGeometry.positions.first.dx,
        QuranSkyGeometry.positions.first.dy,
      );
    for (final p in QuranSkyGeometry.positions.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.025)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );
  }

  @override
  bool shouldRepaint(QuranSkyBackdropPainter old) => old.showPath != showPath;
}

/// The living part: every surah as a star whose light grows with the share of it
/// read, a pulse on the surah being read, and names when zoomed in.
class QuranSkyStarsPainter extends CustomPainter {
  QuranSkyStarsPainter({
    required this.data,
    required this.progress,
    required this.current,
    required this.selected,
    this.today = const {},
    required this.clock,
    required this.scale,
    required this.fitScale,
    required this.accent,
    required this.showNames,
  }) : super(repaint: Listenable.merge([clock, scale]));

  final QuranData data;

  /// Share read per surah, index 0 = Al-Fatihah.
  final List<double> progress;
  final int? current;
  final int? selected;

  /// Surahs in today's khatmah portion: a steady amber ring.
  final Set<int> today;
  final ValueNotifier<double> clock;

  /// The view's absolute zoom, and the zoom at which the whole sky fits.
  final ValueNotifier<double> scale;
  final double fitScale;
  final Color accent;

  /// Arabic names drawn under the stars, laid out once.
  final List<TextPainter> showNames;

  static List<TextPainter> layoutNames(QuranData data) => [
    for (final s in data.surahs)
      TextPainter(
        text: TextSpan(
          text: s.nameArabic,
          style: const TextStyle(
            fontFamily: AppFonts.display,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout(),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock.value;
    final zoom = scale.value;
    final relativeZoom = zoom / fitScale;
    final glow = Paint();
    final core = Paint();

    for (var i = 0; i < 114; i++) {
      final s = data.surahs[i];
      final c = QuranSkyGeometry.positions[i];
      final r = QuranSkyGeometry.radius(s);
      final tint = QuranSkyGeometry.tint(s);
      final p = progress[i];
      final twinkle = 0.85 + 0.15 * math.sin(t * (0.8 + (i % 7) * 0.13) + i);
      final light = (0.32 + 0.68 * p) * twinkle;

      final gr = r * (2.6 + 3.5 * p);
      glow.shader = RadialGradient(
        colors: [
          tint.withValues(alpha: 0.35 * light),
          tint.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: c, radius: gr));
      canvas.drawCircle(c, gr, glow);
      core.color = Color.lerp(
        tint,
        Colors.white,
        0.4 * p,
      )!.withValues(alpha: light);
      canvas.drawCircle(c, r, core);

      // A finished surah earns a four-pointed sparkle.
      if (p >= 0.999) {
        final spark = Paint()
          ..color = Colors.white.withValues(alpha: 0.55 * twinkle)
          ..strokeWidth = 0.8;
        canvas.drawLine(c - Offset(r * 3.2, 0), c + Offset(r * 3.2, 0), spark);
        canvas.drawLine(c - Offset(0, r * 3.2), c + Offset(0, r * 3.2), spark);
      }

      if (today.contains(i + 1)) {
        canvas.drawCircle(
          c,
          r + 6,
          Paint()
            ..color = accent.withValues(alpha: 0.55)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
      if (i + 1 == current) {
        final pulse = (t * 0.8) % 1;
        canvas.drawCircle(
          c,
          r + 4 + pulse * 14,
          Paint()
            ..color = accent.withValues(alpha: 0.8 * (1 - pulse))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
      }
      if (i + 1 == selected) {
        canvas.drawCircle(
          c,
          r + 5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4,
        );
      }

      // Names appear once the sky is zoomed enough to read them, or for the
      // selected and current surahs.
      final named = relativeZoom > 1.9 || i + 1 == selected || i + 1 == current;
      if (named) {
        final tp = showNames[i];
        canvas.save();
        // Names keep the same size on screen whatever the zoom.
        canvas.translate(c.dx, c.dy + r + 3);
        canvas.scale(1 / zoom);
        canvas.translate(-tp.width / 2, 0);
        canvas.saveLayer(
          Offset.zero & tp.size,
          Paint()
            ..color = Colors.white.withValues(
              alpha: i + 1 == selected ? 1 : 0.7,
            ),
        );
        tp.paint(canvas, Offset.zero);
        canvas.restore();
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(QuranSkyStarsPainter old) =>
      old.progress != progress ||
      old.current != current ||
      old.selected != selected ||
      old.today != today ||
      old.accent != accent;
}
