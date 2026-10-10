import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Shakes of the phone, from our own platform channel (ShakeStreamHandler on
/// Android and iOS). Silent where there is no sensor.
abstract final class Shake {
  static const _channel = EventChannel('dev.adez.sabeeli/shake');

  /// Shared by every listener (see [Tilt] for why one stream per channel).
  static final _raw = _channel.receiveBroadcastStream();

  static Stream<void> watch() {
    if (kIsWeb ||
        !(defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return const Stream.empty();
    }
    return _raw.map((_) {}).handleError((Object _) {});
  }
}

/// Opens the user's own mail app with a report ready to send: the recipient,
/// the subject, the text and the screenshot attached. Nothing leaves the
/// phone until the user sends it there.
abstract final class ReportMail {
  static const _channel = MethodChannel('dev.adez.sabeeli/report');

  /// False when no mail app could be opened.
  static Future<bool> compose({
    required String to,
    required String subject,
    required String body,
    String? attachmentPath,
  }) async {
    try {
      return await _channel.invokeMethod<bool>('email', {
            'to': to,
            'subject': subject,
            'body': body,
            'path': ?attachmentPath,
          }) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

/// Opens a web page in the user's browser (our own channel; no package).
abstract final class ExternalUrl {
  static const _channel = MethodChannel('dev.adez.sabeeli/url');

  static Future<bool> open(String url) async {
    try {
      return await _channel.invokeMethod<bool>('open', url) ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
