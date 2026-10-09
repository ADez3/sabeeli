/// Errors thrown by data sources. Repositories catch them and convert them to a
/// [Failure] through `ErrorHandler`, so nothing above the data layer sees an exception.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class StorageException extends AppException {
  const StorageException(super.message);
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class LocationDisabledException extends AppException {
  const LocationDisabledException(super.message);
}

final class LocationPermissionException extends AppException {
  const LocationPermissionException(super.message, {this.permanently = false});

  final bool permanently;
}

final class UnsupportedException extends AppException {
  const UnsupportedException(super.message);
}
