import 'package:equatable/equatable.dart';

class Dhikr extends Equatable {
  const Dhikr({
    required this.id,
    required this.arabic,
    required this.transliteration,
  });

  final String id;
  final String arabic;
  final String transliteration;

  @override
  List<Object?> get props => [id, arabic, transliteration];
}

/// The common tasbih phrases.
abstract final class DhikrPresets {
  static const all = <Dhikr>[
    Dhikr(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'SubhanAllah',
    ),
    Dhikr(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
    ),
    Dhikr(
      id: 'allahuakbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
    ),
    Dhikr(
      id: 'tahlil',
      arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illa Allah',
    ),
    Dhikr(
      id: 'istighfar',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
    ),
    Dhikr(
      id: 'subhanallah_wabihamdihi',
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
    ),
    Dhikr(
      id: 'hawqala',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
    ),
    Dhikr(
      id: 'salawat',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      transliteration: 'Allahumma salli ala Muhammad',
    ),
  ];

  static const targets = [33, 99, 100, 0];
}

class TasbihData extends Equatable {
  const TasbihData({
    this.dhikrId = 'subhanallah',
    this.count = 0,
    this.target = 33,
    this.rounds = 0,
    this.totals = const {},
    this.vibrate = true,
  });

  final String dhikrId;
  final int count;

  /// 0 means no target: count freely.
  final int target;
  final int rounds;

  /// Lifetime count per dhikr id.
  final Map<String, int> totals;
  final bool vibrate;

  Dhikr get dhikr => DhikrPresets.all.firstWhere(
    (d) => d.id == dhikrId,
    orElse: () => DhikrPresets.all.first,
  );

  int get total => totals[dhikrId] ?? 0;

  TasbihData copyWith({
    String? dhikrId,
    int? count,
    int? target,
    int? rounds,
    Map<String, int>? totals,
    bool? vibrate,
  }) => TasbihData(
    dhikrId: dhikrId ?? this.dhikrId,
    count: count ?? this.count,
    target: target ?? this.target,
    rounds: rounds ?? this.rounds,
    totals: totals ?? this.totals,
    vibrate: vibrate ?? this.vibrate,
  );

  Map<String, dynamic> toJson() => {
    'dhikr': dhikrId,
    'count': count,
    'target': target,
    'rounds': rounds,
    'totals': totals,
    'vibrate': vibrate,
  };

  factory TasbihData.fromJson(Map<String, dynamic> json) => TasbihData(
    dhikrId: json['dhikr'] as String? ?? 'subhanallah',
    count: (json['count'] as num?)?.toInt() ?? 0,
    target: (json['target'] as num?)?.toInt() ?? 33,
    rounds: (json['rounds'] as num?)?.toInt() ?? 0,
    totals: (json['totals'] as Map<String, dynamic>? ?? const {}).map(
      (k, v) => MapEntry(k, (v as num).toInt()),
    ),
    vibrate: json['vibrate'] as bool? ?? true,
  );

  @override
  List<Object?> get props => [dhikrId, count, target, rounds, totals, vibrate];
}
