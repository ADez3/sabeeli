import 'dart:async';
import 'dart:io';

import 'exceptions.dart';
import 'failures.dart';

/// The single place where thrown errors become [Failure]s.
///
/// Repositories call [toFailure] in their catch blocks; keeping the mapping here means
/// a new exception type is handled once rather than in every repository.
abstract final class ErrorHandler {
  static Failure toFailure(Object error) => switch (error) {
    StorageException(:final message) => StorageFailure(message: message),
    NetworkException(:final message) => NetworkFailure(message: message),
    LocationDisabledException(:final message) => LocationDisabledFailure(
      message: message,
    ),
    LocationPermissionException(:final message, :final permanently) =>
      LocationPermissionFailure(message: message, permanently: permanently),
    UnsupportedException(:final message) => UnsupportedFailure(
      message: message,
    ),
    SocketException() ||
    HttpException() ||
    TimeoutException() => NetworkFailure(message: error.toString()),
    FormatException(:final message) => StorageFailure(message: message),
    _ => UnknownFailure(message: error.toString()),
  };
}
