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

  /// The Today tile and the Qibla screen listen at the same time while the tab
  /// changes. Each `receiveBroadcastStream()` call installs its own handler on
  /// the channel, replacing the previous one, and the first to cancel stops the
  /// sensor for both, so the Qibla screen stayed still until the app was
  /// resumed. Every listener shares one stream per position instead.
  Stream<Object?>? _raw;
  Coordinates? _rawFor;

  Stream<Object?> _shared(Coordinates? position) {
    if (_raw == null || _rawFor != position) {
      _rawFor = position;
      _raw = _channel.receiveBroadcastStream(
        position == null
            ? null
            : {'latitude': position.latitude, 'longitude': position.longitude},
      );
    }
    return _raw!;
  }

  /// [position] lets Android correct magnetic north to true north; iOS does this
  /// itself once Core Location has a fix.
  Stream<CompassReading> headings(Coordinates? position) =>
      _shared(position)
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
