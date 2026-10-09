import 'package:equatable/equatable.dart';

enum HijriMethod { ummAlQura, tabular }

/// The user's calendar choices. See [AdjustedHijriCalendar] for how they combine.
class HijriSettings extends Equatable {
  const HijriSettings({
    this.method = HijriMethod.ummAlQura,
    this.dayOffset = 0,
    this.monthOverrides = const {},
  });

  final HijriMethod method;

  /// −2…+2 days applied to every month.
  final int dayOffset;

  /// Announced first day of specific months, keyed by Hijri month index.
  final Map<int, DateTime> monthOverrides;

  HijriSettings copyWith({
    HijriMethod? method,
    int? dayOffset,
    Map<int, DateTime>? monthOverrides,
  }) => HijriSettings(
    method: method ?? this.method,
    dayOffset: dayOffset ?? this.dayOffset,
    monthOverrides: monthOverrides ?? this.monthOverrides,
  );

  Map<String, dynamic> toJson() => {
    'method': method.name,
    'offset': dayOffset,
    'overrides': {
      for (final e in monthOverrides.entries)
        '${e.key}': '${e.value.year}-${e.value.month}-${e.value.day}',
    },
  };

  factory HijriSettings.fromJson(Map<String, dynamic> json) => HijriSettings(
    method:
        HijriMethod.values.asNameMap()[json['method']] ?? HijriMethod.ummAlQura,
    dayOffset: ((json['offset'] as num?)?.toInt() ?? 0).clamp(-2, 2),
    monthOverrides: _parseOverrides(
      json['overrides'] as Map<String, dynamic>? ?? const {},
    ),
  );

  static Map<int, DateTime> _parseOverrides(Map<String, dynamic> raw) {
    final result = <int, DateTime>{};
    for (final e in raw.entries) {
      final index = int.tryParse(e.key);
      if (index != null) result[index] = _parseDate(e.value as String);
    }
    return result;
  }

  static DateTime _parseDate(String s) {
    final p = s.split('-').map(int.parse).toList();
    return DateTime(p[0], p[1], p[2]);
  }

  @override
  List<Object?> get props => [method, dayOffset, monthOverrides];
}
