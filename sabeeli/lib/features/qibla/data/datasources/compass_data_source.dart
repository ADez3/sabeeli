import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/compass_reading.dart';

/// The device heading, from our own platform channel (CompassStreamHandler on
/// Android and iOS) rather than a compass package.
@lazySingleton
class CompassDataSource {
  static const _channel = EventChannel('dev.adez.sabeeli/compass');

  /// [position] lets Android correct magnetic north to true north; iOS does this
  /// itself once Core Location has a fix.
  Stream<CompassReading> headings(Coordinates? position) => _channel
      .receiveBroadcastStream(
        position == null
            ? null
            : {'latitude': position.latitude, 'longitude': position.longitude},
      )
      .map((event) {
        final map = (event as Map).cast<String, Object?>();
        return CompassReading(
          heading: (map['heading'] as num).toDouble(),
          trueNorth: map['trueNorth'] as bool? ?? false,
          accuracy: (map['accuracy'] as num?)?.toInt() ?? 0,
        );
      })
      .handleError((Object error) {
        if (error is PlatformException || error is MissingPluginException) {
          throw const UnsupportedException('No compass on this device');
        }
        throw error;
      });
}
