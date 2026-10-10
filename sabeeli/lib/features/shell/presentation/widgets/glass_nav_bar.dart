import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/sky_ambience.dart';

class GlassNavItem {
  const GlassNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// A compact frosted-glass capsule floating above the content. The active tab is
/// marked by a solid disc that slides between the icons.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<GlassNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _slot = 64.0;
  static const _height = 62.0;
  static const _inset = 7.0;
  static const _disc = _height - _inset * 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final width = _slot * items.length + _inset * 2;

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 18),
      child: Center(
        heightFactor: 1,
        child: DecoratedBox(
          // The shadow sits outside the clip so the capsule looks lifted.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_height / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.45 : 0.14),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_height / 2),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                width: width,
                height: _height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_height / 2),
                  // A breath of the real sky in the glass.
                  color: Color.lerp(
                    dark
                        ? colors.surfaceHigh.withValues(alpha: 0.62)
                        : Colors.white.withValues(alpha: 0.72),
                    context.sky.colors.middle.withValues(alpha: 0.62),
                    dark ? 0.10 : 0.05,
                  ),
                ),
                // The rim is drawn on top so it takes no layout space: light
                // catching the top edge and fading round the sides.
                foregroundDecoration: _RimDecoration(dark: dark),
                child: Stack(
                  children: [
                    AnimatedPositionedDirectional(
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutBack,
                      top: _inset,
                      start:
                          _inset + selectedIndex * _slot + (_slot - _disc) / 2,
                      child: Container(
                        width: _disc,
                        height: _disc,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.35),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _inset),
                      child: Row(
                        children: [
                          for (final (i, item) in items.indexed)
                            _NavIcon(
                              item: item,
                              selected: i == selectedIndex,
                              onTap: () {
                                if (i != selectedIndex) {
                                  HapticFeedback.selectionClick();
                                }
                                onSelected(i);
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: item.label,
      child: Semantics(
        selected: selected,
        button: true,
        label: item.label,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: GlassNavBar._slot,
            height: GlassNavBar._height,
            child: Center(
              child: TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 250),
                tween: ColorTween(
                  end: selected ? colors.onPrimary : colors.textMuted,
                ),
                builder: (_, color, _) =>
                    Icon(item.icon, size: 22, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RimDecoration extends Decoration {
  const _RimDecoration({required this.dark});

  final bool dark;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _RimPainter(dark);
}

class _RimPainter extends BoxPainter {
  _RimPainter(this.dark);

  final bool dark;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular(rect.height / 2),
    );
    final top = dark
        ? Colors.white.withValues(alpha: 0.22)
        : Colors.white.withValues(alpha: 0.9);
    final bottom = dark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.08);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ).createShader(rect),
    );
  }
}
