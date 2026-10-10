import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/result/result.dart';
import '../entities/compass_reading.dart';
import '../entities/land_mask.dart';

abstract interface class QiblaRepository {
  Stream<Result<CompassReading>> compass(Coordinates? position);

  Future<Result<LandMask>> landMask();
}
