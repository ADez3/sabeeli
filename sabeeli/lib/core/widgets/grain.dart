import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// A fine film grain laid over whatever is beneath it (shaders/grain.frag).
/// Static: it costs one shader pass when the area repaints.
class Grain extends StatelessWidget {
  const Grain({super.key, this.opacity = 0.035});

  final double opacity;

  static final Future<ui.FragmentProgram> _program =
      ui.FragmentProgram.fromAsset('shaders/grain.frag');

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: FutureBuilder<ui.FragmentProgram>(
        future: _program,
        builder: (context, snap) => snap.data == null
            ? const SizedBox.expand()
            : CustomPaint(
                size: Size.infinite,
                painter: _GrainPainter(
                  snap.data!.fragmentShader(),
                  opacity,
                  MediaQuery.devicePixelRatioOf(context),
                ),
              ),
      ),
    ),
  );
}

class _GrainPainter extends CustomPainter {
  _GrainPainter(this.shader, this.opacity, this.pixelRatio);

  final ui.FragmentShader shader;
  final double opacity;
  final double pixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, 7)
      ..setFloat(3, opacity);
    // Grain at physical-pixel size: draw scaled down so one speck is one pixel.
    canvas.save();
    canvas.scale(1 / pixelRatio);
    canvas.drawRect(
      Offset.zero & (size * pixelRatio),
      Paint()..shader = shader,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GrainPainter old) =>
      old.opacity != opacity || old.pixelRatio != pixelRatio;
}
