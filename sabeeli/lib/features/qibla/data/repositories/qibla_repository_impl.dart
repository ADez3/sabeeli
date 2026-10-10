import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/compass_reading.dart';
import '../../domain/entities/land_mask.dart';
import '../../domain/repositories/qibla_repository.dart';
import '../datasources/compass_data_source.dart';
import '../datasources/land_mask_data_source.dart';

@LazySingleton(as: QiblaRepository)
class QiblaRepositoryImpl implements QiblaRepository {
  const QiblaRepositoryImpl(this._compass, this._land);
  final CompassDataSource _compass;
  final LandMaskDataSource _land;

  @override
  Future<Result<LandMask>> landMask() async {
    try {
      return Ok(await _land.load());
    } catch (e) {
      return Err(ErrorHandler.toFailure(e));
    }
  }

  @override
  Stream<Result<CompassReading>> compass(Coordinates? position) => _compass
      .headings(position)
      .transform(
        StreamTransformer.fromHandlers(
          handleData: (reading, sink) => sink.add(Ok(reading)),
          handleError: (error, _, sink) =>
              sink.add(Err(ErrorHandler.toFailure(error))),
        ),
      );
}
