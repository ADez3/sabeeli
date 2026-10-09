import 'package:equatable/equatable.dart';

class DhikrItem extends Equatable {
  const DhikrItem({
    required this.id,
    required this.arabic,
    required this.count,
    this.translation,
    this.transliteration,
    this.reference,
    this.virtue,
  });

  final int id;

  /// Verbatim from Hisn al-Muslim.
  final String arabic;

  /// How many times it is said.
  final int count;
  final String? translation;
  final String? transliteration;
  final String? reference;
  final String? virtue;

  @override
  List<Object?> get props => [id];
}

class AzkarCategory extends Equatable {
  const AzkarCategory({
    required this.id,
    required this.key,
    required this.titleArabic,
    required this.titleEnglish,
    required this.items,
  });

  final int id;

  /// Stable name for the categories the app features (morning, evening,
  /// after_prayer, sleep, waking…); null for the rest.
  final String? key;
  final String titleArabic;
  final String titleEnglish;
  final List<DhikrItem> items;

  @override
  List<Object?> get props => [id];
}
