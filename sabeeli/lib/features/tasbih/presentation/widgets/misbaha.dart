import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A string of 33 prayer beads with its long imam bead and tassel. Drag the beads
/// round with a thumb, as on a real misbaha: every bead that passes the top counts
/// once. A tap advances a single bead.
class Misbaha extends StatefulWidget {
  const Misbaha({super.key, required this.onCount, required this.child});

  /// Called once per bead counted.
  final VoidCallback onCount;

  /// Shown in the middle of the ring (the dhikr and the count).
  final Widget child;

  static const beads = 33;

  @override
  State<Misbaha> createState() => _MisbahaState();
}

class _MisbahaState extends State<Misbaha> with SingleTickerProviderStateMixin {
  static const _step = 2 * math.pi / Misbaha.beads;

  /// Total turn of the ring in radians; only ever grows (counting goes one way).
  late final AnimationController _turn = AnimationController.unbounded(
    vsync: this,
  );
  double? _lastAngle;
  int _counted = 0;

  Offset _center(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    return box.size.center(Offset.zero);
  }

  void _countUpTo(double turn) {
    final steps = (turn / _step + 1e-6).floor();
    while (_counted < steps) {
      _counted++;
      widget.onCount();
    }
  }

  void _onPanStart(DragStartDetails d) {
    _turn.stop();
    _lastAngle = (d.localPosition - _center(context)).direction;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    final angle = (d.localPosition - _center(context)).direction;
    var delta = angle - (_lastAngle ?? angle);
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;
    _lastAngle = angle;
    // Clockwise only: dragging back does not un-count a bead.
    if (delta > 0) {
      _turn.value += delta;
      _countUpTo(_turn.value);
    }
  }

  void _onPanEnd(DragEndDetails _) {
    // Settle on a bead: past half way the bead is pulled through and counted.
    final target = (_turn.value / _step).round() * _step;
    _turn
        .animateTo(
          target,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        )
        .then((_) {
          if (mounted) _countUpTo(_turn.value);
        });
  }

  void _onTap() {
    final target = (_turn.value / _step).floor() * _step + _step;
    _turn.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
    );
    _countUpTo(target);
  }

  @override
  void dispose() {
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: _onTap,
    onPanStart: _onPanStart,
    onPanUpdate: _onPanUpdate,
    onPanEnd: _onPanEnd,
    child: Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(painter: _MisbahaPainter(_turn)),
          ),
        ),
        Center(child: widget.child),
      ],
    ),
  );
}

class _MisbahaPainter extends CustomPainter {
  _MisbahaPainter(this.turn) : super(repaint: turn);

  final Animation<double> turn;

  static const _step = 2 * math.pi / Misbaha.beads;
  static const _resinLight = Color(0xFFF6CC8E);
  static const _resinDark = Color(0xFF8E4F1E);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final ringR = size.shortestSide * 0.38;
    final beadR = ringR * math.sin(_step / 2) * 0.86;

    // The cord.
    canvas.drawCircle(
      c,
      ringR,
      Paint()
        ..color = const Color(0xFF6E4A2A).withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // The imam bead sits between the last and the first bead.
    final imamAngle = -math.pi / 2 + turn.value - _step / 2;
    for (var i = 0; i < Misbaha.beads; i++) {
      final a = -math.pi / 2 + turn.value - _step * (i + 1);
      final p = c + Offset.fromDirection(a, ringR);
      // The bead nearest the top is the one under the thumb: a touch larger.
      final top = (_wrap(a + math.pi / 2)).abs() < _step / 2;
      final r = top ? beadR * 1.12 : beadR;
      canvas.drawCircle(p + const Offset(0, 2.5), r, shadow);
      canvas.drawCircle(p, r, _beadPaint(p, r));
    }

    _paintImam(canvas, c, ringR, beadR, imamAngle, shadow);
  }

  void _paintImam(
    Canvas canvas,
    Offset c,
    double ringR,
    double beadR,
    double angle,
    Paint shadow,
  ) {
    final p = c + Offset.fromDirection(angle, ringR);
    final out = Offset.fromDirection(angle);

    // The tassel hangs outwards from the imam bead.
    final tasselStart = p + out * beadR * 1.3;
    final tassel = Paint()
      ..color = const Color(0xFF8E4F1E)
      ..strokeWidth = 1.2;
    for (var k = -3; k <= 3; k++) {
      final spread = Offset.fromDirection(angle + math.pi / 2) * (k * 1.6);
      canvas.drawLine(
        tasselStart,
        tasselStart + out * beadR * 3.2 + spread * 2,
        tassel,
      );
    }

    canvas.save();
    canvas.translate(p.dx, p.dy);
    // Long axis along the radius, so it fits between its neighbours.
    canvas.rotate(angle);
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: beadR * 2.6,
      height: beadR * 1.15,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.shift(const Offset(0, 2.5)),
        Radius.circular(beadR),
      ),
      shadow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(beadR)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_resinLight, _resinDark],
        ).createShader(rect),
    );
    canvas.restore();
  }

  Paint _beadPaint(Offset p, double r) => Paint()
    ..shader = RadialGradient(
      center: const Alignment(-0.35, -0.4),
      radius: 1.0,
      colors: const [Color(0xFFFFF0D6), _resinLight, _resinDark],
      stops: const [0, 0.35, 1],
    ).createShader(Rect.fromCircle(center: p, radius: r));

  static double _wrap(double a) {
    final r = (a + math.pi) % (2 * math.pi);
    return (r < 0 ? r + 2 * math.pi : r) - math.pi;
  }

  @override
  bool shouldRepaint(_MisbahaPainter old) => false;
}
