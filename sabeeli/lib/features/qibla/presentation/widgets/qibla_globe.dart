import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/astronomy/qibla.dart';
import '../../../../core/platform/live_state.dart';
import '../../domain/entities/land_mask.dart';

/// The Earth as a globe of dots with the great-circle path from the user to the
/// Kaaba: the direction of prayer as it really runs over the planet. Opens by
/// turning from the user towards Makkah while the path draws itself; drag to spin.
class QiblaGlobe extends StatefulWidget {
  const QiblaGlobe({
    super.key,
    required this.user,
    required this.mask,
    required this.youLabel,
    required this.makkahLabel,
  });

  final Coordinates user;
  final LandMask mask;
  final String youLabel;
  final String makkahLabel;

  @override
  State<QiblaGlobe> createState() => _QiblaGlobeState();
}

class _QiblaGlobeState extends State<QiblaGlobe>
    with SingleTickerProviderStateMixin, LiveStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  /// The travelling light and the pulses: a 3 s loop at 30 fps, only while the
  /// globe is on screen.
  final _clock = FrameClock();
  late List<Coordinates> _path = Qibla.pathFrom(widget.user, steps: 96);
  late List<(double, double)> _land = _landPoints(widget.mask);

  /// Extra spin added by dragging, in degrees.
  Offset _drag = Offset.zero;

  @override
  void initState() {
    super.initState();
    _intro.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _intro.value = 1;
    onLiveChanged(isLive);
  }

  @override
  void onLiveChanged(bool live) {
    if (live && !MediaQuery.disableAnimationsOf(context)) {
      _clock.start();
    } else {
      _clock.stop();
    }
  }

  @override
  void didUpdateWidget(QiblaGlobe old) {
    super.didUpdateWidget(old);
    if (old.user != widget.user) _path = Qibla.pathFrom(widget.user, steps: 96);
    if (old.mask != widget.mask) _land = _landPoints(widget.mask);
  }

  /// Land cells sampled roughly evenly over the sphere: fewer per row towards the
  /// poles, where the meridians crowd together.
  static List<(double, double)> _landPoints(LandMask mask) {
    final points = <(double, double)>[];
    for (var lat = -84.0; lat <= 84; lat += 2) {
      final step = (2 / math.cos(lat * math.pi / 180)).clamp(2.0, 30.0);
      for (var lon = -180.0; lon < 180; lon += step) {
        if (mask.isLand(lat, lon)) {
          points.add((lat * math.pi / 180, lon * math.pi / 180));
        }
      }
    }
    return points;
  }

  @override
  void dispose() {
    _intro.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onPanUpdate: (d) => setState(() {
      _drag += Offset(-d.delta.dx * 0.35, d.delta.dy * 0.35);
      _drag = Offset(_drag.dx, _drag.dy.clamp(-70.0, 70.0));
    }),
    child: AnimatedBuilder(
      animation: Listenable.merge([_intro, _clock]),
      builder: (_, _) {
        final t = Curves.easeInOutCubic.transform(_intro.value);
        // Turn from the user to the middle of the route.
        final mid = _path[_path.length ~/ 2];
        final lon0 =
            _lerpAngle(widget.user.longitude, mid.longitude, t) + _drag.dx;
        final lat0 =
            (widget.user.latitude +
                    (mid.latitude - widget.user.latitude) * t +
                    _drag.dy)
                .clamp(-80.0, 80.0);
        return CustomPaint(
          size: Size.infinite,
          painter: _GlobePainter(
            lat0: lat0,
            lon0: lon0,
            land: _land,
            path: _path,
            drawn: Curves.easeOut.transform(
              ((_intro.value - 0.25) / 0.75).clamp(0.0, 1.0),
            ),
            pulse: (_clock.value / 3) % 1,
            youLabel: widget.youLabel,
            makkahLabel: widget.makkahLabel,
          ),
        );
      },
    ),
  );

  static double _lerpAngle(double a, double b, double t) {
    var d = (b - a) % 360;
    if (d > 180) d -= 360;
    if (d < -180) d += 360;
    return a + d * t;
  }
}

class _GlobePainter extends CustomPainter {
  _GlobePainter({
    required this.lat0,
    required this.lon0,
    required this.land,
    required this.path,
    required this.drawn,
    required this.pulse,
    required this.youLabel,
    required this.makkahLabel,
  });

  final double lat0;
  final double lon0;
  final List<(double, double)> land;
  final List<Coordinates> path;

  /// Share of the path drawn so far, 0…1.
  final double drawn;

  /// 0…1, repeating: the light travelling along the path and the pulses.
  final double pulse;
  final String youLabel;
  final String makkahLabel;

  static const _moonlight = Color(0xFF9DB2FF);
  static const _amber = Color(0xFFF4B860);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * 0.42;
    final phi0 = lat0 * math.pi / 180;
    final lam0 = lon0 * math.pi / 180;
    final sinPhi0 = math.sin(phi0);
    final cosPhi0 = math.cos(phi0);

    /// Orthographic projection; null on the far side of the globe.
    (Offset, double)? project(double phi, double lam) {
      final cosPhi = math.cos(phi);
      final dLam = lam - lam0;
      final cosC = sinPhi0 * math.sin(phi) + cosPhi0 * cosPhi * math.cos(dLam);
      if (cosC < 0) return null;
      final x = cosPhi * math.sin(dLam);
      final y = cosPhi0 * math.sin(phi) - sinPhi0 * cosPhi * math.cos(dLam);
      return (c + Offset(x, -y) * r, cosC);
    }

    (Offset, double)? projectDeg(Coordinates p) =>
        project(p.latitude * math.pi / 180, p.longitude * math.pi / 180);

    // Atmosphere and sphere.
    canvas.drawCircle(
      c,
      r * 1.22,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _moonlight.withValues(alpha: 0.22),
            _moonlight.withValues(alpha: 0),
          ],
          stops: const [0.78, 1],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.22)),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.4),
          colors: [Color(0xFF1C2556), Color(0xFF0A0D24)],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    // Graticule every 30°.
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    for (var lat = -60; lat <= 60; lat += 30) {
      _polyline(
        canvas,
        [
          for (var lon = -180; lon <= 180; lon += 4)
            (lat * math.pi / 180, lon * math.pi / 180),
        ],
        project,
        grid,
      );
    }
    for (var lon = -180; lon < 180; lon += 30) {
      _polyline(
        canvas,
        [
          for (var lat = -90; lat <= 90; lat += 4)
            (lat * math.pi / 180, lon * math.pi / 180),
        ],
        project,
        grid,
      );
    }

    // Land as dots, brighter where they face the viewer.
    final dot = Paint();
    for (final (phi, lam) in land) {
      final p = project(phi, lam);
      if (p == null) continue;
      final (o, depth) = p;
      dot.color = _moonlight.withValues(alpha: 0.18 + 0.55 * depth);
      canvas.drawCircle(o, 0.9 + 0.9 * depth, dot);
    }

    // The path, drawn up to [drawn].
    final visible = (path.length * drawn).floor();
    final line = Paint()
      ..color = _amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..color = _amber.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final segment = [
      for (final p in path.take(visible))
        (p.latitude * math.pi / 180, p.longitude * math.pi / 180),
    ];
    _polyline(canvas, segment, project, glow);
    _polyline(canvas, segment, project, line);

    // A light travelling along the finished path.
    if (drawn >= 1) {
      final i = (pulse * (path.length - 1)).floor();
      final p = projectDeg(path[i]);
      if (p != null) {
        canvas.drawCircle(
          p.$1,
          9,
          Paint()
            ..shader = RadialGradient(
              colors: [Colors.white, Colors.white.withValues(alpha: 0)],
            ).createShader(Rect.fromCircle(center: p.$1, radius: 9)),
        );
      }
    }

    // The user and the Kaaba.
    final you = projectDeg(path.first);
    if (you != null) {
      canvas.drawCircle(you.$1, 5, Paint()..color = _moonlight);
      canvas.drawCircle(
        you.$1,
        5 + 10 * pulse,
        Paint()
          ..color = _moonlight.withValues(alpha: 0.6 * (1 - pulse))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      _label(canvas, youLabel, you.$1 + const Offset(0, 10), _moonlight);
    }
    final kaaba = projectDeg(path.last);
    if (kaaba != null && drawn > 0.95) {
      final k = kaaba.$1;
      canvas.drawCircle(
        k,
        18,
        Paint()
          ..shader = RadialGradient(
            colors: [
              _amber.withValues(alpha: 0.6),
              _amber.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: k, radius: 18)),
      );
      canvas.drawRect(
        Rect.fromCenter(center: k, width: 9, height: 9),
        Paint()..color = const Color(0xFF151515),
      );
      canvas.drawRect(
        Rect.fromLTWH(k.dx - 4.5, k.dy - 2.5, 9, 1.6),
        Paint()..color = _amber,
      );
      _label(canvas, makkahLabel, k + const Offset(0, 10), _amber);
    }
  }

  /// Draws the visible runs of a path of (latitude, longitude) points in radians.
  static void _polyline(
    Canvas canvas,
    List<(double, double)> points,
    (Offset, double)? Function(double, double) project,
    Paint paint,
  ) {
    Path? run;
    final out = Path();
    for (final (phi, lam) in points) {
      final p = project(phi, lam);
      if (p == null) {
        run = null;
        continue;
      }
      if (run == null) {
        out.moveTo(p.$1.dx, p.$1.dy);
        run = out;
      } else {
        out.lineTo(p.$1.dx, p.$1.dy);
      }
    }
    canvas.drawPath(out, paint);
  }

  static void _label(Canvas canvas, String text, Offset at, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2, 0));
  }

  @override
  bool shouldRepaint(_GlobePainter old) => true;
}
