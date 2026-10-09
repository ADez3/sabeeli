import 'package:equatable/equatable.dart';

/// Why an operation produced no value, as seen by the domain and presentation layers.
///
/// Sealed so a widget can `switch` over every case and pick a localized message;
/// [message] is a developer-facing detail for logs, never shown to the user.
sealed class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// A bundled asset or stored value could not be read or parsed.
final class StorageFailure extends Failure {
  const StorageFailure({required super.message});
}

/// No connection, or a download failed in transit.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Location services are switched off on the device.
final class LocationDisabledFailure extends Failure {
  const LocationDisabledFailure({required super.message});
}

/// The user refused location access. [permanently] means the system will not ask
/// again, so the UI should send them to the app settings instead.
final class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure({
    required super.message,
    this.permanently = false,
  });

  final bool permanently;

  @override
  List<Object?> get props => [message, permanently];
}

/// The device lacks the hardware a feature needs (for example a compass).
final class UnsupportedFailure extends Failure {
  const UnsupportedFailure({required super.message});
}

/// Anything not anticipated above.
final class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
