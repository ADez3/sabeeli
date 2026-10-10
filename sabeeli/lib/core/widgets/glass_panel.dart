import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Frosted glass for content laid over a scene (the home sky). Always light-on-dark:
/// the scene beneath is dark enough at the bottom in every theme.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppSpacing.radiusMd,
    this.shape = BoxShape.rectangle,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final circle = shape == BoxShape.circle;
    final border = circle ? null : BorderRadius.circular(radius);
    Widget panel = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        shape: circle
            ? CircleBorder(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
              )
            : RoundedRectangleBorder(
                borderRadius: border!,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
        child: InkWell(
          onTap: onTap,
          customBorder: circle
              ? const CircleBorder()
              : RoundedRectangleBorder(borderRadius: border!),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    return circle
        ? ClipOval(child: panel)
        : ClipRRect(borderRadius: border!, child: panel);
  }
}
