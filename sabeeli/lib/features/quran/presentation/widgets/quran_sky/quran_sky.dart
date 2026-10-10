import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/platform/live_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/quran_entities.dart';
import 'quran_sky_painters.dart';

/// The Quran as a night sky: one star per surah. Pinch to zoom, drag to wander,
/// tap a star to select its surah.
class QuranSky extends StatefulWidget {
  const QuranSky({
    super.key,
    required this.data,
    required this.readPages,
    required this.current,
    required this.selected,
    required this.onSelected,
    this.today = const {},
  });

  final QuranData data;
  final Set<int> readPages;

  /// The surah being read, marked with a pulse.
  final int? current;
  final int? selected;
  final ValueChanged<int?> onSelected;

  /// Surahs of today's khatmah portion.
  final Set<int> today;

  @override
  State<QuranSky> createState() => _QuranSkyState();
}

class _QuranSkyState extends State<QuranSky>
    with SingleTickerProviderStateMixin, LiveStateMixin {
  final _transform = TransformationController();

  /// Twinkle and pulse at 30 fps, only while the sky is on screen.
  final _clock = FrameClock();
  final _scale = ValueNotifier(1.0);
  late List<TextPainter> _names = QuranSkyStarsPainter.layoutNames(widget.data);
  late List<double> _progress = _computeProgress();
  Size? _fittedTo;
  double _fitScale = 1;
  Matrix4 _fitted = Matrix4.identity();
  EdgeInsets _margin = const EdgeInsets.all(400);

  /// Eases the sky back to its fitted place after a zoom-out past it.
  late final _settle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  Animation<Matrix4>? _settleTo;

  @override
  void initState() {
    super.initState();
    _transform.addListener(
      () => _scale.value = _transform.value.getMaxScaleOnAxis(),
    );
    _settle.addListener(() {
      final to = _settleTo;
      if (to != null) _transform.value = to.value;
    });
  }

  /// Zoomed out past the fit, the sky floats back to the centre.
  void _onInteractionEnd(ScaleEndDetails _) {
    if (_transform.value.getMaxScaleOnAxis() >= _fitScale) return;
    _settleTo = Matrix4Tween(
      begin: _transform.value,
      end: _fitted,
    ).animate(CurvedAnimation(parent: _settle, curve: Curves.easeOutCubic));
    _settle.forward(from: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
  void didUpdateWidget(QuranSky old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) {
      _names = QuranSkyStarsPainter.layoutNames(widget.data);
    }
    if (old.readPages != widget.readPages || old.data != widget.data) {
      _progress = _computeProgress();
    }
  }

  List<double> _computeProgress() => [
    for (var s = 1; s <= 114; s++)
      widget.data.surahProgress(s, widget.readPages),
  ];

  /// Fits the spiral to the viewport once, centred.
  void _fit(Size viewport) {
    if (_fittedTo == viewport) return;
    _fittedTo = viewport;
    const extent = 860.0; // the spiral's diameter with its glow
    _fitScale = viewport.shortestSide / extent;
    final s = _fitScale;
    final dx = (viewport.width - QuranSkyGeometry.size * s) / 2;
    final dy = (viewport.height - QuranSkyGeometry.size * s) / 2;
    _fitted = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(s, s, 1, 1);
    _transform.value = _fitted.clone();
    _scale.value = s;

    // InteractiveViewer keeps the child plus this margin over the whole
    // viewport, and pins it to the top-left corner when it gets smaller. The
    // margin must therefore still fill the screen at the smallest zoom, or
    // zooming out sticks the sky to the top.
    final minScale = _fitScale * _minZoom;
    double need(double side) =>
        math.max(400, (side / minScale - QuranSkyGeometry.size) / 2 + 1);
    _margin = EdgeInsets.symmetric(
      horizontal: need(viewport.width),
      vertical: need(viewport.height),
    );
  }

  static const _minZoom = 0.8;

  void _onTap(TapUpDetails d) {
    final zoom = _transform.value.getMaxScaleOnAxis();
    final hit = QuranSkyGeometry.hit(d.localPosition, widget.data, 18 / zoom);
    if (hit != null) HapticFeedback.selectionClick();
    widget.onSelected(hit == widget.selected ? null : hit);
  }

  @override
  void dispose() {
    _settle.dispose();
    _transform.dispose();
    _clock.dispose();
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _fit(constraints.biggest);
        return InteractiveViewer(
          transformationController: _transform,
          constrained: false,
          minScale: _fitScale * _minZoom,
          maxScale: _fitScale * 6,
          boundaryMargin: _margin,
          onInteractionStart: (_) => _settle.stop(),
          onInteractionEnd: _onInteractionEnd,
          child: GestureDetector(
            onTapUp: _onTap,
            child: SizedBox.square(
              dimension: QuranSkyGeometry.size,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(painter: QuranSkyBackdropPainter()),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: QuranSkyStarsPainter(
                        data: widget.data,
                        progress: _progress,
                        current: widget.current,
                        selected: widget.selected,
                        today: widget.today,
                        clock: _clock,
                        scale: _scale,
                        fitScale: _fitScale,
                        accent: context.colors.accent,
                        showNames: _names,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
