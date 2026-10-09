import 'package:equatable/equatable.dart';

import '../../../../core/astronomy/coordinates.dart';

/// Where the user prays from: the input to prayer times and the Qibla.
class SavedLocation extends Equatable {
  const SavedLocation({
    required this.coordinates,
    this.name,
    this.countryCode,
    this.isManual = false,
  });

  final Coordinates coordinates;

  /// City or area, for display only. Null until reverse geocoding succeeds (it needs
  /// the network; the coordinates alone are enough for every calculation).
  final String? name;

  /// ISO 3166-1 alpha-2, used to pick the default calculation method.
  final String? countryCode;

  /// Chosen from search rather than read from the GPS. A manual location is never
  /// silently replaced by a GPS fix.
  final bool isManual;

  SavedLocation copyWith({String? name, String? countryCode}) => SavedLocation(
    coordinates: coordinates,
    name: name ?? this.name,
    countryCode: countryCode ?? this.countryCode,
    isManual: isManual,
  );

  @override
  List<Object?> get props => [coordinates, name, countryCode, isManual];
}
