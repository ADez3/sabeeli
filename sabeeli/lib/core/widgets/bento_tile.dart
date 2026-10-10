import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/motion.dart';

/// A tile of the Today bento: a raised surface with a hairline rim and, when
/// [glow] is set, a soft light in its corner. It sinks a little under the finger
/// and springs back.
class BentoTile extends StatefulWidget {
  const BentoTile({
    super.key,
    required this.child,
    this.onTap,
    this.glow,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// A colour that lights the tile from its top corner (amber for the sacred).
  final Color? glow;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  static const radius = 28.0;

  @override
  State<BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<BentoTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController.unbounded(
    vsync: this,
    value: 0,
  );

  void _springTo(double target) => _press.animateWith(
    SpringSimulation(Motion.spatial, _press.value, target, _press.velocity),
  );

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final glow = widget.glow;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BentoTile.radius),
      side: BorderSide(color: colors.hairline),
    );

    final content = Stack(
      children: [
        if (glow != null)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(BentoTile.radius),
                gradient: RadialGradient(
                  center: AlignmentDirectional.topStart.resolve(
                    Directionality.of(context),
                  ),
                  radius: 1.1,
                  colors: [
                    glow.withValues(alpha: dark ? 0.20 : 0.12),
                    glow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        Padding(padding: widget.padding, child: widget.child),
      ],
    );

    // Ink (not a DecoratedBox) so the ripple is painted above the surface; the
    // rim is drawn in front of both.
    final tile = Container(
      foregroundDecoration: ShapeDecoration(shape: shape),
      decoration: ShapeDecoration(
        shape: shape,
        shadows: dark
            ? null
            : [
                BoxShadow(
                  color: colors.text.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(colors.surfaceHigh, colors.text, dark ? 0.03 : 0)!,
                colors.surfaceHigh,
              ],
            ),
          ),
          child: widget.onTap == null
              ? content
              : InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onTap!();
                  },
                  onHighlightChanged: (down) => _springTo(down ? 1 : 0),
                  child: content,
                ),
        ),
      ),
    );

    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: AnimatedBuilder(
        animation: _press,
        builder: (_, child) =>
            Transform.scale(scale: 1 - 0.03 * _press.value, child: child),
        child: tile,
      ),
    );
  }
}
