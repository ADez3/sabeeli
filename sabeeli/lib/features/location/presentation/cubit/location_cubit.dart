import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/saved_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/location_usecases.dart';

enum LocationStatus { initial, locating, ready, failed }

class LocationState extends Equatable {
  const LocationState({
    this.status = LocationStatus.initial,
    this.location,
    this.failure,
  });

  final LocationStatus status;

  /// Kept through a failed refresh: an old position is still the right city.
  final SavedLocation? location;
  final Failure? failure;

  LocationState copyWith({
    LocationStatus? status,
    SavedLocation? location,
    Failure? Function()? failure,
  }) => LocationState(
    status: status ?? this.status,
    location: location ?? this.location,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, location, failure];
}

/// App-wide: prayer times, the Qibla and the home screen all read the same location.
@lazySingleton
class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._getSaved, this._locate, this._save, this._repository)
    : super(const LocationState());

  final GetSavedLocationUseCase _getSaved;
  final LocateDeviceUseCase _locate;
  final SaveLocationUseCase _save;
  final LocationRepository _repository;

  Future<void> load() async {
    final result = await _getSaved(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LocationStatus.failed, failure: () => failure),
      ),
      (location) => emit(
        state.copyWith(
          status: location == null
              ? LocationStatus.initial
              : LocationStatus.ready,
          location: location,
        ),
      ),
    );
  }

  DateTime? _lastRefresh;

  /// Refreshes from the device unless the user picked a city by hand. Called on
  /// start and resume so a traveller's times follow them, at most every half
  /// hour: opening the app often must not wake the location radio each time.
  Future<void> refreshIfAutomatic(String language) async {
    final current = state.location;
    if (current != null && current.isManual) return;
    if (current == null) return; // First launch waits for the user to opt in.
    final last = _lastRefresh;
    final now = DateTime.now();
    if (last != null && now.difference(last) < const Duration(minutes: 30)) {
      return;
    }
    _lastRefresh = now;
    await locate(language, silent: true);
  }

  Future<void> locate(String language, {bool silent = false}) async {
    if (!silent) {
      emit(
        state.copyWith(status: LocationStatus.locating, failure: () => null),
      );
    }
    final result = await _locate(LanguageParams(language));
    result.fold(
      (failure) {
        if (silent && state.location != null) return;
        emit(
          state.copyWith(status: LocationStatus.failed, failure: () => failure),
        );
      },
      (location) =>
          emit(LocationState(status: LocationStatus.ready, location: location)),
    );
  }

  Future<void> choose(SavedLocation location) async {
    emit(LocationState(status: LocationStatus.ready, location: location));
    await _save(location);
  }

  Future<void> openAppSettings() => _repository.openAppSettings();
  Future<void> openLocationSettings() => _repository.openLocationSettings();
}
