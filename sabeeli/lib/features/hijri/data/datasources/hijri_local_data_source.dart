import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/hijri/hijri_calendar.dart';
import '../../../../core/hijri/hijri_date.dart';
import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/hijri_settings.dart';

@lazySingleton
class HijriLocalDataSource {
  HijriLocalDataSource(this._store);
  final KeyValueStore _store;

  static const _key = 'hijri.settings';
  static const _tableAsset = 'assets/hijri/ummalqura.json';

  UmmAlQuraCalendar? _ummAlQura;

  HijriSettings readSettings() {
    final json = _store.getJson(_key);
    return json == null ? const HijriSettings() : HijriSettings.fromJson(json);
  }

  Future<void> writeSettings(HijriSettings settings) =>
      _store.setJson(_key, settings.toJson());

  /// The Umm al-Qura month-start table, loaded once.
  ///
  /// Asset shape (built by `tool/data/build_hijri.py`): `{"startYear": 1343,
  /// "startMonthIndex": 0, "mjd": [...]}`, where `mjd[i]` is the Modified Julian Day
  /// of the 1st of the i-th month after Muharram of startYear; the last entry only
  /// closes the final month.
  Future<UmmAlQuraCalendar> ummAlQura() async {
    final cached = _ummAlQura;
    if (cached != null) return cached;
    final json = jsonDecode(
      await rootBundle.loadString(_tableAsset),
    ) as Map<String, dynamic>;
    final first =
        HijriDate((json['startYear'] as num).toInt(), 1, 1).monthIndex +
        ((json['startMonthIndex'] as num?)?.toInt() ?? 0);
    final calendar = UmmAlQuraCalendar(
      firstMonthIndex: first,
      monthStarts: [
        for (final mjd in json['mjd'] as List<dynamic>)
          (mjd as num).toInt() + _mjdToJdn,
      ],
    );
    _ummAlQura = calendar;
    return calendar;
  }

  /// Modified Julian Day 0 is JDN 2400001 (17 Nov 1858).
  static const _mjdToJdn = 2400001;
}
