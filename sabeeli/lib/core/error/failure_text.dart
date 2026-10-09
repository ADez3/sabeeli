import '../../l10n/l10n.dart';
import 'failures.dart';

/// The one place a [Failure] becomes text the user reads.
String failureText(AppLocalizations l10n, Failure failure) => switch (failure) {
  LocationDisabledFailure() => l10n.locationDisabled,
  LocationPermissionFailure(permanently: true) => l10n.locationDeniedForever,
  LocationPermissionFailure() => l10n.locationDenied,
  NetworkFailure() => l10n.networkError,
  UnsupportedFailure() => l10n.compassUnavailable,
  StorageFailure() || UnknownFailure() => l10n.genericError,
};
