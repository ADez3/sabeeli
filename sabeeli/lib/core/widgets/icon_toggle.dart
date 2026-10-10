import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/motion.dart';

/// A small capsule switching between views (Sky / List, Compass / Globe): a
/// pill slides under the chosen icon. [onSky] draws it light, for scenes.
class IconToggle<T> extends StatelessWidget {
  const IconToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.onSky = false,
  });

  final List<(T, IconData, String)> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool onSky;

  static const _slot = 44.0;
  static const _height = 36.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = onSky ? Colors.white : colors.text;
    final index = options.indexWhere((o) => o.$1 == selected);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_height),
        color: onSky
            ? Colors.white.withValues(alpha: 0.10)
            : colors.surfaceHigh,
        border: Border.all(
          color: onSky ? Colors.white.withValues(alpha: 0.14) : colors.hairline,
        ),
      ),
      child: SizedBox(
        width: _slot * options.length,
        height: _height,
        child: Stack(
          children: [
            AnimatedPositionedDirectional(
              duration: Motion.component,
              curve: Curves.easeOutBack,
              start: _slot * index,
              top: 0,
              bottom: 0,
              width: _slot,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_height),
                  color: onSky
                      ? Colors.white.withValues(alpha: 0.22)
                      : colors.primary,
                ),
              ),
            ),
            Row(
              children: [
                for (final (value, icon, label) in options)
                  Tooltip(
                    message: label,
                    child: Semantics(
                      button: true,
                      selected: value == selected,
                      label: label,
                      excludeSemantics: true,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (value == selected) return;
                          HapticFeedback.selectionClick();
                          onChanged(value);
                        },
                        child: SizedBox(
                          width: _slot,
                          height: _height,
                          child: TweenAnimationBuilder<Color?>(
                            duration: Motion.micro,
                            tween: ColorTween(
                              end: value == selected
                                  ? (onSky ? Colors.white : colors.onPrimary)
                                  : fg.withValues(alpha: 0.55),
                            ),
                            builder: (_, c, _) =>
                                Icon(icon, size: 18, color: c),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
