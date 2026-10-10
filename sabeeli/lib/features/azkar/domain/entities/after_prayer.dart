import 'package:equatable/equatable.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../quran/domain/entities/quran_entities.dart';

/// One step of the adhkar said after an obligatory prayer: a dhikr from Hisn
/// al-Muslim, or a passage of the Quran (Ayat al-Kursi, the three Quls).
class AfterPrayerStep extends Equatable {
  const AfterPrayerStep({
    required this.id,
    required this.count,
    this.countAfterFajrAndMaghrib,
    this.arabic,
    this.quranFrom,
    this.quranTo,
    this.only,
    this.translation,
    this.transliteration,
    this.reference,
    this.virtue,
  }) : assert((arabic == null) != (quranFrom == null));

  final String id;

  /// Verbatim from Hisn al-Muslim; null for a Quran passage.
  final String? arabic;

  /// The Quran passage, in Hafs numbering; null for a dhikr.
  final AyahRef? quranFrom;
  final AyahRef? quranTo;

  final int count;

  /// The Quls are said three times after Fajr and Maghrib.
  final int? countAfterFajrAndMaghrib;

  /// Said only after these prayers; null means after every prayer.
  final Set<Prayer>? only;

  final String? translation;
  final String? transliteration;
  final String? reference;
  final String? virtue;

  bool get isQuran => quranFrom != null;

  bool saidAfter(Prayer prayer) => only == null || only!.contains(prayer);

  int countAfter(Prayer prayer) =>
      (prayer == Prayer.fajr || prayer == Prayer.maghrib)
      ? countAfterFajrAndMaghrib ?? count
      : count;

  @override
  List<Object?> get props => [id];
}
