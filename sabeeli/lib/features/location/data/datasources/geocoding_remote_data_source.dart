import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/network/http_json.dart';
import '../../domain/entities/saved_location.dart';

/// Place names from OpenStreetMap's Nominatim, called directly instead of through a
/// geocoding package: two GET requests, and no API key.
///
/// Usage policy: at most one request per second and an identifying User-Agent, both
/// of which a user typing a city name stays far within.
@lazySingleton
class GeocodingRemoteDataSource {
  const GeocodingRemoteDataSource(this._http);
  final HttpJson _http;

  static const _host = 'nominatim.openstreetmap.org';

  Future<SavedLocation> reverse(
    Coordinates c, {
    required String language,
  }) async {
    // Only a position rounded to about a kilometre leaves the device: enough to
    // name the town, not to find the user.
    final json = await _http.get(
      Uri.https(_host, '/reverse', {
        'format': 'jsonv2',
        'lat': c.latitude.toStringAsFixed(2),
        'lon': c.longitude.toStringAsFixed(2),
        'zoom': '10',
        'accept-language': language,
      }),
    ) as Map<String, dynamic>;
    final address = json['address'] as Map<String, dynamic>? ?? const {};
    return SavedLocation(
      coordinates: c,
      name: _placeName(address) ?? json['name'] as String?,
      countryCode: (address['country_code'] as String?)?.toUpperCase(),
    );
  }

  Future<List<SavedLocation>> search(
    String query, {
    required String language,
  }) async {
    final json = await _http.get(
      Uri.https(_host, '/search', {
        'format': 'jsonv2',
        'q': query,
        'limit': '10',
        'addressdetails': '1',
        'featureType': 'settlement',
        'accept-language': language,
      }),
    ) as List<dynamic>;
    return [
      for (final item in json.cast<Map<String, dynamic>>())
        SavedLocation(
          coordinates: Coordinates(
            latitude: double.parse(item['lat'] as String),
            longitude: double.parse(item['lon'] as String),
          ),
          name: _searchLabel(item),
          countryCode:
              ((item['address'] as Map<String, dynamic>?)?['country_code']
                      as String?)
                  ?.toUpperCase(),
          isManual: true,
        ),
    ];
  }

  static String? _placeName(Map<String, dynamic> a) =>
      (a['city'] ??
              a['town'] ??
              a['village'] ??
              a['municipality'] ??
              a['county'] ??
              a['state'])
          as String?;

  /// "Casablanca, Morocco" rather than Nominatim's full administrative chain.
  static String _searchLabel(Map<String, dynamic> item) {
    final a = item['address'] as Map<String, dynamic>? ?? const {};
    final place = _placeName(a) ?? item['name'] as String? ?? '';
    final region = a['state'] as String?;
    final country = a['country'] as String?;
    return [
      place,
      if (region != null && region != place) region,
      ?country,
    ].where((s) => s.isNotEmpty).join(', ');
  }
}
