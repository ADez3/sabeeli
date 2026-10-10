import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/sky_ambience.dart';
import 'grain.dart';

/// The backdrop of most screens: the app's background, tinted at the top by the
/// real sky above the user, with a faint twilight aurora and film grain. The
/// tint is low on purpose; text contrast never depends on it.
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child, this.strength = 1});

  final Widget child;

  /// 0…1: how much of the sky shows (1 for hubs, lower for reading screens).
  final double strength;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sky = context.sky.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tint = (dark ? 0.32 : 0.16) * strength;
    final top = Color.lerp(colors.background, sky.middle, tint)!;
    final glow = Color.lerp(colors.background, sky.horizon, tint * 0.7)!;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [top, glow, colors.background],
                stops: const [0, 0.32, 0.72],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.9, -0.95),
                radius: 0.9,
                colors: [
                  colors.secondary.withValues(alpha: 0.10 * strength),
                  colors.secondary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Grain(opacity: dark ? 0.04 : 0.03),
          child,
        ],
      ),
    );
  }
}
