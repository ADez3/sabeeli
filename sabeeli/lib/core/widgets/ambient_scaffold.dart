import 'package:flutter/material.dart';

import 'ambient_background.dart';

/// A [Scaffold] over the [AmbientBackground]: pushed pages share the tint of
/// the real sky with the tabs, a little fainter so reading stays calm.
class AmbientScaffold extends StatelessWidget {
  const AmbientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.strength = 0.6,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final double strength;

  @override
  Widget build(BuildContext context) => AmbientBackground(
    strength: strength,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: body,
    ),
  );
}
