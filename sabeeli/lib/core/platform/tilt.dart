import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Phone tilt for parallax effects, from our own platform channel
/// (TiltStreamHandler on Android and iOS).
///
/// Emits a smoothed offset in −1…1 on each axis, centred on the way the phone is
/// held when listening starts, so the scene sits still until the phone moves. On
/// platforms without the sensor the stream simply stays silent.
abstract final class Tilt {
  static const _channel = EventChannel('dev.adez.sabeeli/tilt');

  /// One stream for every listener. Each `receiveBroadcastStream()` call
  /// installs its own handler on the channel, replacing the previous one, and
  /// the first to cancel stops the sensor for all: two skies alive at once (the
  /// welcome handing over to Today) would freeze the second.
  static final _raw = _channel.receiveBroadcastStream();

  static Stream<Offset> watch() {
    if (kIsWeb ||
        !(defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return const Stream.empty();
    }
    Offset? rest;
    var smooth = Offset.zero;
    return _raw
        .map((event) {
          final list = (event as List).cast<num>();
          final raw = Offset(list[0].toDouble(), list[1].toDouble());
          rest ??= raw;
          // Let the resting point drift slowly so a change of posture recentres.
          rest = Offset.lerp(rest, raw, 0.01);
          final delta = raw - rest!;
          smooth = Offset.lerp(smooth, delta, 0.2)!;
          return Offset(
            (smooth.dx / 0.35).clamp(-1.0, 1.0),
            (smooth.dy / 0.35).clamp(-1.0, 1.0),
          );
        })
        .handleError((Object _) {});
  }
}
