import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/land_mask.dart';

/// The land mask bundled in assets/geo (see assets/SOURCES.md), decoded once.
@lazySingleton
class LandMaskDataSource {
  LandMask? _cache;

  Future<LandMask> load() async {
    final cached = _cache;
    if (cached != null) return cached;
    final json = jsonDecode(
      await rootBundle.loadString('assets/geo/land_mask.json'),
    ) as Map<String, dynamic>;
    final mask = LandMask(
      width: (json['w'] as num).toInt(),
      height: (json['h'] as num).toInt(),
      bits: base64Decode(json['bits'] as String),
    );
    _cache = mask;
    return mask;
  }
}
