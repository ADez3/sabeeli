import 'package:flutter/widgets.dart';

/// Material 3 window size classes. Layouts switch on these, never on raw widths, so
/// phones, foldables, tablets, desktop and web share one set of decisions.
enum WindowSize {
  compact,
  medium,
  expanded;

  static WindowSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) return compact;
    if (width < 840) return medium;
    return expanded;
  }
}

extension WindowSizeX on BuildContext {
  WindowSize get windowSize => WindowSize.of(this);

  /// Bottom padding for a tab's scrollable content. Under the floating navigation
  /// bar the shell reports the bar's height as bottom padding, so this clears it.
  double get navBarClearance => MediaQuery.paddingOf(this).bottom + 24;
}

/// Centres content and caps its width, so a phone layout does not stretch into
/// unreadable line lengths on a tablet or desktop window.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 720});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
