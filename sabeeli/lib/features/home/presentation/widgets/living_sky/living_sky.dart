import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/astronomy/coordinates.dart';
import '../../../../../core/astronomy/solar.dart';
import '../../../../../core/platform/live_state.dart';
import '../../../../../core/platform/tilt.dart';
import '../../../../../core/theme/sky_ambience.dart';
import '../../../../../core/theme/sky.dart';
import 'landscape_painter.dart';
import 'sky_painter.dart';

/// The sky above the user right now: the sun and the moon where they really are,
/// the moon in its real phase, stars after dusk, and dunes with a mosque on the
/// horizon. Tilting the phone moves the layers at different depths.
///
/// Everything is painted in code, so it costs no assets and is never the same twice.
class LivingSky extends StatefulWidget {
  const LivingSky({
    super.key,
    required this.coordinates,
    this.horizonFraction = 0.6,
  });

  final Coordinates coordinates;

  /// Height of the horizon as a fraction of the scene height.
  final double horizonFraction;

  /// The sky colours for a place and time, shared with screens that echo the scene.
  static SkyColors colorsAt(Coordinates where, DateTime now) {
    final sun = Solar.sunAt(where, now);
    return SkyPalette.at(sun.altitude, morning: sun.hourAngle < 0);
  }

  @override
  State<LivingSky> createState() => _LivingSkyState();
}

class _LivingSkyState extends State<LivingSky> with LiveStateMixin {
  /// Drives twinkling and shooting stars at 30 fps, only while on screen.
  final _clock = FrameClock();
  final _tilt = ValueNotifier(Offset.zero);
  StreamSubscription<Offset>? _tiltSub;
  Timer? _minute;
  DateTime _now = SkyClock.now();
  bool _animate = true;

  @override
  void didChangeDependencies() {
    // Honour the system "reduce motion" setting: a still sky, no tilt.
    _animate = !MediaQuery.disableAnimationsOf(context);
    super.didChangeDependencies();
    if (isLive) onLiveChanged(true);
  }

  /// Nothing runs out of sight: no clock, no tilt sensor, no timer.
  @override
  void onLiveChanged(bool live) {
    if (live) {
      // The sun moves a quarter of a degree a minute: once a minute is smooth
      // enough. Catch up at once after a pause.
      if (_minute == null) {
        _minute = Timer.periodic(
          const Duration(minutes: 1),
          (_) => setState(() => _now = SkyClock.now()),
        );
        setState(() => _now = SkyClock.now());
      }
      if (_animate) {
        _clock.start();
        _tiltSub ??= Tilt.watch().listen((o) => _tilt.value = o);
      } else {
        _stopMotion();
      }
    } else {
      _minute?.cancel();
      _minute = null;
      _stopMotion();
    }
  }

  void _stopMotion() {
    _clock.stop();
    _tiltSub?.cancel();
    _tiltSub = null;
    _tilt.value = Offset.zero;
  }

  @override
  void dispose() {
    _minute?.cancel();
    _tiltSub?.cancel();
    _clock.dispose();
    _tilt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final where = widget.coordinates;
    final sun = Solar.sunAt(where, _now);
    final colors = SkyPalette.at(sun.altitude, morning: sun.hourAngle < 0);
    final h = widget.horizonFraction;

    // Nearer layers move further with the tilt: that difference is the depth.
    Widget layer(double depth, Widget child) => Positioned.fill(
      left: -40,
      right: -40,
      top: -30,
      bottom: -30,
      child: ValueListenableBuilder<Offset>(
        valueListenable: _tilt,
        builder: (_, tilt, child) => Transform.translate(
          offset: Offset(-tilt.dx * depth, tilt.dy * depth * 0.5),
          child: child,
        ),
        child: RepaintBoundary(child: child),
      ),
    );

    return ClipRect(
      child: Stack(
        children: [
          layer(
            6,
            CustomPaint(
              painter: SkyPainter(
                colors: colors,
                sun: sun,
                moon: Solar.moonAt(where, _now),
                moonAge: Solar.moonAge(_now),
                horizonFraction: h,
                clock: _clock,
                animate: _animate,
              ),
            ),
          ),
          for (final (i, depth) in const [(0, 12.0), (1, 22.0), (2, 36.0)])
            layer(
              depth,
              CustomPaint(
                painter: LandscapePainter(
                  layer: i,
                  colors: colors,
                  horizonFraction: h,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
