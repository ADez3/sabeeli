import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/widgets/misbaha_icon.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/glass_nav_bar.dart';

/// The four places of the app: a floating glass bar on phones, a rail on wider
/// windows.
class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _go(int index) => navigationShell.goBranch(
    index,
    // Tapping the current tab again returns to its root, as on every platform.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget Function(Color) lucide(IconData icon) =>
        (color) => Icon(icon, size: 22, color: color);
    final destinations = <(Widget Function(Color), String)>[
      (lucide(LucideIcons.sunMoon), l10n.navToday),
      (lucide(LucideIcons.bookOpen), l10n.navQuran),
      ((color) => MisbahaIcon(size: 22, color: color), l10n.navDhikr),
      (lucide(LucideIcons.compass), l10n.qibla),
    ];

    final Widget body = navigationShell;

    if (context.windowSize == WindowSize.compact) {
      // Pages scroll under the floating bar; they pad their ends with
      // `navBarClearance` so the last item can be scrolled clear of it.
      return Scaffold(
        extendBody: true,
        body: body,
        bottomNavigationBar: GlassNavBar(
          selectedIndex: navigationShell.currentIndex,
          onSelected: _go,
          items: [
            for (final (icon, label) in destinations)
              GlassNavItem(icon: icon, label: label),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _go,
              extended: context.windowSize == WindowSize.expanded,
              labelType: context.windowSize == WindowSize.expanded
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (final (icon, label) in destinations)
                  NavigationRailDestination(
                    icon: Builder(
                      builder: (context) =>
                          icon(IconTheme.of(context).color ?? Colors.grey),
                    ),
                    label: Text(label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
