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
      // The app draws edge to edge: the sky runs under the system bars, but the
      // content stops above them. With three-button navigation the bar is tall
      // and would otherwise cover the last rows of every list.
      body: SafeArea(top: appBar == null, child: body),
    ),
  );
}
