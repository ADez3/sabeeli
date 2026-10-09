import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/router/app_router.dart';

void main() {
  test('custom-scheme links fold their host back into the path', () {
    expect(
      normalizeDeepLink(Uri.parse('sabeeli://quran/2?ayah=255')),
      '/quran/2?ayah=255',
    );
    expect(normalizeDeepLink(Uri.parse('sabeeli://prayer')), '/prayer');
    expect(
      normalizeDeepLink(Uri.parse('sabeeli://quran/page/50')),
      '/quran/page/50',
    );
  });

  test('in-app paths pass through untouched', () {
    expect(normalizeDeepLink(Uri.parse('/home')), isNull);
  });
}
