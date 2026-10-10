import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/router/app_router.dart';

void main() {
  test('custom-scheme links fold their host back into the path', () {
    expect(
      normalizeDeepLink(Uri.parse('sabeeli://quran/2?ayah=255')),
      '/quran/2?ayah=255',
    );
    expect(
      normalizeDeepLink(Uri.parse('sabeeli://quran/page/50')),
      '/quran/page/50',
    );
    expect(
      normalizeDeepLink(Uri.parse('sabeeli://dhikr/after-prayer?prayer=fajr')),
      '/dhikr/after-prayer?prayer=fajr',
    );
  });

  test('links from earlier versions still land in the right place', () {
    // Prayer notifications carry this payload.
    expect(normalizeDeepLink(Uri.parse('sabeeli://prayer')), '/today/day');
    expect(normalizeDeepLink(Uri.parse('/home')), '/today');
    expect(normalizeDeepLink(Uri.parse('/more/qibla')), '/qibla');
    expect(normalizeDeepLink(Uri.parse('/azkar/25')), '/dhikr/25');
    expect(normalizeDeepLink(Uri.parse('/more/tasbih')), '/dhikr/tasbih');
  });

  test('in-app paths pass through untouched', () {
    expect(normalizeDeepLink(Uri.parse('/today')), isNull);
    expect(normalizeDeepLink(Uri.parse('/quran/2?ayah=255')), isNull);
    expect(normalizeDeepLink(Uri.parse('/today/settings/prayer')), isNull);
  });
}
