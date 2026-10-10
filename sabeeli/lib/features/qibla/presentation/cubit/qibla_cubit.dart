import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/astronomy/qibla.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/compass_reading.dart';
import '../../domain/usecases/watch_compass_usecase.dart';

enum QiblaStatus { initial, noLocation, active, noCompass }

class QiblaState extends Equatable {
  const QiblaState({
    this.status = QiblaStatus.initial,
    this.bearing,
    this.distanceKm,
    this.reading,
    this.failure,
  });

  final QiblaStatus status;

  /// Qibla direction in degrees from true north.
  final double? bearing;
  final double? distanceKm;
  final CompassReading? reading;
  final Failure? failure;

  /// Degrees the user must turn clockwise (negative: anticlockwise), in −180…180.
  double? get turn {
    final b = bearing;
    final r = reading;
    if (b == null || r == null) return null;
    return ((b - r.heading + 540) % 360) - 180;
  }

  /// Within the width of a prayer row.
  bool get isFacing => (turn?.abs() ?? 999) < 3;

  @override
  List<Object?> get props => [status, bearing, distanceKm, reading, failure];
}

/// The compass sensor costs battery: the Qibla screen pauses it whenever it is
/// out of sight (another tab, the app in the background) and resumes it after.
@injectable
class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit(this._watch) : super(const QiblaState());

  final WatchCompassUseCase _watch;
  StreamSubscription<void>? _subscription;
  bool _wasFacing = false;
  Coordinates? _position;
  bool _paused = false;

  void start(Coordinates? position) {
    _position = position;
    _subscription?.cancel();
    _subscription = null;
    if (position == null) {
      emit(const QiblaState(status: QiblaStatus.noLocation));
      return;
    }
    emit(
      QiblaState(
        status: QiblaStatus.active,
        bearing: Qibla.bearingFrom(position),
        distanceKm: Qibla.distanceKm(position),
      ),
    );
    if (!_paused) _listen(position);
  }

  void pause() {
    _paused = true;
    _subscription?.cancel();
    _subscription = null;
  }

  void resume() {
    _paused = false;
    final position = _position;
    if (position != null && _subscription == null) _listen(position);
  }

  void _listen(Coordinates position) {
    _subscription = _watch(position).listen((result) {
      result.fold(
        (failure) => emit(
          QiblaState(
            status: QiblaStatus.noCompass,
            bearing: state.bearing,
            distanceKm: state.distanceKm,
            failure: failure,
          ),
        ),
        (reading) {
          final next = QiblaState(
            status: QiblaStatus.active,
            bearing: state.bearing,
            distanceKm: state.distanceKm,
            reading: reading,
          );
          // A single tick when the needle lines up, so the user can find the
          // direction without staring at the screen.
          if (next.isFacing && !_wasFacing) HapticFeedback.mediumImpact();
          _wasFacing = next.isFacing;
          emit(next);
        },
      );
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
