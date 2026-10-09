import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/app_sync.dart';
import '../widgets/glass_nav_bar.dart';

/// The five top-level destinations: a floating glass bar on phones, a rail on wider
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
    final destinations = [
      (LucideIcons.house, l10n.navHome),
      (LucideIcons.bookOpen, l10n.navQuran),
      (LucideIcons.clock, l10n.navPrayer),
      (LucideIcons.sparkles, l10n.navAzkar),
      (LucideIcons.layoutGrid, l10n.navMore),
    ];

    final body = AppSync(child: navigationShell);

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
                    icon: Icon(icon),
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
