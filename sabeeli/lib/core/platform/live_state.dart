import 'dart:async';

import 'package:flutter/widgets.dart';

/// For states that run timers, sensors or animations: [isLive] is true only
/// while the app is in the foreground and the widget is on screen (not in a
/// hidden tab, where [TickerMode] is off). [onLiveChanged] is where work is
/// started and stopped, so nothing runs in the background or out of sight.
mixin LiveStateMixin<T extends StatefulWidget> on State<T> {
  late final AppLifecycleListener _lifecycle;
  bool _foreground = true;
  bool _visible = true;
  bool _live = false;

  bool get isLive => _live;

  /// Called when [isLive] changes, and once when the widget first goes live.
  void onLiveChanged(bool live);

  @override
  void initState() {
    super.initState();
    final state = WidgetsBinding.instance.lifecycleState;
    _foreground = state == null || _isForeground(state);
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        _foreground = _isForeground(state);
        _update();
      },
    );
  }

  /// Inactive (the notification shade over the app) still counts as visible.
  static bool _isForeground(AppLifecycleState s) =>
      s == AppLifecycleState.resumed || s == AppLifecycleState.inactive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TickerMode.valuesOf(context).enabled;
    _update();
  }

  void _update() {
    final live = mounted && _foreground && _visible;
    if (live == _live) return;
    _live = live;
    onLiveChanged(live);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }
}

/// Seconds since [start], advanced by a timer at [fps] rather than by every
/// display frame: ambient scenes do not need 60–120 redraws a second, and a
/// stopped clock costs nothing.
class FrameClock extends ValueNotifier<double> {
  FrameClock({this.fps = 30}) : super(0);

  final int fps;
  final _watch = Stopwatch();
  Timer? _timer;

  bool get isRunning => _timer != null;

  void start() {
    if (_timer != null) return;
    _watch.start();
    _timer = Timer.periodic(
      Duration(microseconds: 1000000 ~/ fps),
      (_) => value = _watch.elapsedMicroseconds / 1e6,
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
