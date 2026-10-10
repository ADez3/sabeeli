import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../astronomy/coordinates.dart';
import '../astronomy/solar.dart';
import 'sky.dart';

/// The clock the painted skies follow. In debug builds it can be shifted to
/// preview other hours: `--dart-define=SKY_MINUTES_OFFSET=-840`.
abstract final class SkyClock {
  static const _debugMinutesOffset = int.fromEnvironment('SKY_MINUTES_OFFSET');

  static DateTime now() {
    final now = DateTime.now();
    return kReleaseMode
        ? now
        : now.add(const Duration(minutes: _debugMinutesOffset));
  }
}

/// The real sky above the user right now: the sun's altitude and its colours.
@immutable
class SkyNow {
  const SkyNow({
    required this.altitude,
    required this.morning,
    required this.colors,
  });

  /// Before a location is known: a clear night.
  static final night = SkyNow(
    altitude: -30,
    morning: false,
    colors: SkyPalette.at(-30, morning: false),
  );

  final double altitude;
  final bool morning;
  final SkyColors colors;

  bool get isNight => altitude < -6;

  @override
  bool operator ==(Object other) =>
      other is SkyNow && other.altitude == altitude && other.morning == morning;

  @override
  int get hashCode => Object.hash(altitude, morning);
}

/// Provides [SkyNow] to the whole app, recomputed every few minutes, so any
/// screen can take a tint from the real sky (`context.sky`).
class SkyAmbience extends StatefulWidget {
  const SkyAmbience({super.key, required this.where, required this.child});

  final Coordinates? where;
  final Widget child;

  static SkyNow of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SkyScope>()?.sky ??
      SkyNow.night;

  @override
  State<SkyAmbience> createState() => _SkyAmbienceState();
}

class _SkyAmbienceState extends State<SkyAmbience> {
  late SkyNow _sky = _compute();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 3), (_) => _update());
  }

  @override
  void didUpdateWidget(SkyAmbience old) {
    super.didUpdateWidget(old);
    if (old.where != widget.where) _update();
  }

  void _update() {
    final next = _compute();
    if (next != _sky) setState(() => _sky = next);
  }

  SkyNow _compute() {
    final where = widget.where;
    if (where == null) return SkyNow.night;
    final sun = Solar.sunAt(where, SkyClock.now());
    // A tenth of a degree is invisible; rounding keeps rebuilds rare.
    final altitude = (sun.altitude * 10).roundToDouble() / 10;
    final morning = sun.hourAngle < 0;
    return SkyNow(
      altitude: altitude,
      morning: morning,
      colors: SkyPalette.at(altitude, morning: morning),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _SkyScope(sky: _sky, child: widget.child);
}

class _SkyScope extends InheritedWidget {
  const _SkyScope({required this.sky, required super.child});

  final SkyNow sky;

  @override
  bool updateShouldNotify(_SkyScope old) => old.sky != sky;
}

extension SkyAmbienceX on BuildContext {
  SkyNow get sky => SkyAmbience.of(this);
}
