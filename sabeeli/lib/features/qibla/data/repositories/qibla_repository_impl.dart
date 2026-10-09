import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/compass_reading.dart';
import '../../domain/repositories/qibla_repository.dart';
import '../datasources/compass_data_source.dart';

@LazySingleton(as: QiblaRepository)
class QiblaRepositoryImpl implements QiblaRepository {
  const QiblaRepositoryImpl(this._compass);
  final CompassDataSource _compass;

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
