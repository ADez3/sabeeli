import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// One prayer for the home-screen widget, already in the user's language and
/// digits: the widget itself only compares times.
typedef WidgetPrayer = ({String name, DateTime time, String label});

/// The home-screen widget (Android; our own platform channel). Silently does
/// nothing elsewhere.
abstract final class HomeWidget {
  static const _channel = MethodChannel('dev.adez.sabeeli/widget');

  static Future<void> update({
    required List<WidgetPrayer> prayers,
    required String caption,
    required String empty,
  }) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('update', {
        'entries': jsonEncode([
          for (final p in prayers)
            {'n': p.name, 't': p.time.millisecondsSinceEpoch, 'l': p.label},
        ]),
        'caption': caption,
        'empty': empty,
      });
    } on PlatformException {
      // The widget is a nicety; never let it disturb the app.
    } on MissingPluginException {
      // Tests and platforms without the channel.
    }
  }
}
