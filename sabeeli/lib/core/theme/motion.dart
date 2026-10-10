import 'package:flutter/widgets.dart';

/// One motion language for the app. Springs for what the user moves, curves for
/// what appears; worship and reading content never bounces.
abstract final class Motion {
  // Durations
  static const micro = Duration(milliseconds: 160);
  static const component = Duration(milliseconds: 320);
  static const page = Duration(milliseconds: 480);
  static const ceremonial = Duration(milliseconds: 1000);

  /// Delay between items of a staggered entrance.
  static const stagger = Duration(milliseconds: 40);

  // Curves
  /// Entrances: fast start, long soft landing.
  static const enter = Cubic(0.05, 0.7, 0.1, 1);

  /// Exits: quick and out of the way.
  static const exit = Cubic(0.3, 0, 0.8, 0.15);

  // Springs
  /// Things the user moves (the nav disc, tiles, beads): a slight overshoot.
  static final spatial = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 380,
    ratio: 0.73,
  );

  /// Opacity and colour: no bounce.
  static final effect = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 1600,
    ratio: 1,
  );

  /// Sacred and reading content: settles without overshoot.
  static final calm = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 300,
    ratio: 0.95,
  );

  /// True when the user asked the system to reduce motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}
