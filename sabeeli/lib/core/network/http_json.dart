import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';

import '../error/exceptions.dart';

/// Minimal GET-and-decode over `dart:io`'s [HttpClient].
///
/// The app makes a handful of unauthenticated GETs (place search, translation
/// downloads), which does not justify dio or http as a dependency.
@lazySingleton
class HttpJson {
  HttpJson()
    : _client = HttpClient()..connectionTimeout = const Duration(seconds: 15);

  final HttpClient _client;

  /// Identifies the app, as OpenStreetMap's usage policy requires.
  static const userAgent = 'Sabeeli/0.1 (dev.adez.sabeeli; Flutter)';

  Future<dynamic> get(Uri uri, {Map<String, String> headers = const {}}) async {
    try {
      final request = await _client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, userAgent);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      headers.forEach(request.headers.set);
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw NetworkException('GET $uri → ${response.statusCode}');
      }
      return jsonDecode(body);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw NetworkException('GET $uri timed out');
    } on HttpException catch (e) {
      throw NetworkException(e.message);
    }
  }
}
