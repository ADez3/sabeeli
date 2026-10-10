import 'package:flutter/material.dart';

import '../theme/motion.dart';

/// Text whose digits roll like an odometer when they change: the old digit
/// slides up and out, the new one rises in. Every digit gets a slot as wide as
/// the widest digit, so a ticking countdown never jitters, even in fonts
/// without tabular figures. Works for Western, Arabic-Indic and Persian digits.
class RollingDigits extends StatelessWidget {
  const RollingDigits(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  static bool _isDigit(int c) =>
      (c >= 0x30 && c <= 0x39) ||
      (c >= 0x660 && c <= 0x669) ||
      (c >= 0x6F0 && c <= 0x6F9);

  static final _slotCache = <(TextStyle, double, int), double>{};

  /// Width of the widest of the ten digits in the script of [sample].
  static double _slotWidth(BuildContext context, TextStyle style, int sample) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final zero = sample >= 0x6F0
        ? 0x6F0
        : sample >= 0x660
        ? 0x660
        : 0x30;
    return _slotCache.putIfAbsent((style, scale, zero), () {
      var widest = 0.0;
      for (var d = 0; d < 10; d++) {
        final tp = TextPainter(
          text: TextSpan(text: String.fromCharCode(zero + d), style: style),
          textDirection: TextDirection.ltr,
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        if (tp.width > widest) widest = tp.width;
      }
      return widest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    final runes = text.runes.toList();
    return Semantics(
      label: text,
      excludeSemantics: true,
      // Times read left to right in every locale ("05:12", "٠٥:١٢").
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            for (var i = 0; i < runes.length; i++)
              _isDigit(runes[i])
                  ? SizedBox(
                      // Slots are keyed from the right, so "9:59" → "10:00"
                      // rolls the digits that really changed.
                      key: ValueKey(runes.length - i),
                      width: _slotWidth(context, style, runes[i]),
                      // No clip: it would cut the digits' shadows into boxes;
                      // the rolling digits fade out before they leave the slot.
                      child: AnimatedSwitcher(
                        duration: reduced ? Duration.zero : Motion.component,
                        switchInCurve: Motion.enter,
                        switchOutCurve: Motion.exit,
                        transitionBuilder: _roll,
                        layoutBuilder: (current, previous) => Stack(
                          alignment: Alignment.center,
                          children: [...previous, ?current],
                        ),
                        child: Text(
                          String.fromCharCode(runes[i]),
                          key: ValueKey(runes[i]),
                          style: style,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Text(String.fromCharCode(runes[i]), style: style),
          ],
        ),
      ),
    );
  }

  static Widget _roll(Widget child, Animation<double> a) =>
      _Roll(animation: a, child: child);
}

/// Rises in while its animation runs forwards; leaves upwards when the same
/// animation runs in reverse (as AnimatedSwitcher does for the outgoing child).
class _Roll extends AnimatedWidget {
  const _Roll({required Animation<double> animation, required this.child})
    : super(listenable: animation);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final a = listenable as Animation<double>;
    final leaving = a.status == AnimationStatus.reverse;
    final dy = (1 - a.value) * (leaving ? -0.35 : 0.35);
    return FractionalTranslation(
      translation: Offset(0, dy),
      child: Opacity(
        opacity: Curves.easeIn.transform(a.value.clamp(0.0, 1.0)),
        child: child,
      ),
    );
  }
}
