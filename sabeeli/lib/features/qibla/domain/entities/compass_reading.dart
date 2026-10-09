import 'package:equatable/equatable.dart';

class CompassReading extends Equatable {
  const CompassReading({
    required this.heading,
    required this.trueNorth,
    required this.accuracy,
  });

  /// Degrees clockwise from north that the top of the device points to.
  final double heading;

  /// True north when the platform could correct for magnetic declination.
  final bool trueNorth;

  /// 0 = unreliable … 3 = high. Below 2 the user should calibrate.
  final int accuracy;

  bool get needsCalibration => accuracy < 2;

  @override
  List<Object?> get props => [heading, trueNorth, accuracy];
}
