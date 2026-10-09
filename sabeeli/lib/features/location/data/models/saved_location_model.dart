import '../../../../core/astronomy/coordinates.dart';
import '../../domain/entities/saved_location.dart';

abstract final class SavedLocationModel {
  static SavedLocation fromJson(Map<String, dynamic> json) => SavedLocation(
    coordinates: Coordinates(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      elevation: (json['alt'] as num?)?.toDouble() ?? 0,
    ),
    name: json['name'] as String?,
    countryCode: json['country'] as String?,
    isManual: json['manual'] as bool? ?? false,
  );

  static Map<String, dynamic> toJson(SavedLocation l) => {
    'lat': l.coordinates.latitude,
    'lng': l.coordinates.longitude,
    'alt': l.coordinates.elevation,
    if (l.name != null) 'name': l.name,
    if (l.countryCode != null) 'country': l.countryCode,
    'manual': l.isManual,
  };
}
