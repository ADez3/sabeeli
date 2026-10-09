import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../../../../core/utils/numerals.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.languageCode,
    this.numeralStyle = NumeralStyle.auto,
  });

  /// Dark is the default: the app is designed dark-first.
  final ThemeMode themeMode;

  /// Null follows the device language.
  final String? languageCode;

  /// Digits for every number in the app, Quran ayah numbers included.
  final NumeralStyle numeralStyle;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? Function()? languageCode,
    NumeralStyle? numeralStyle,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    languageCode: languageCode != null ? languageCode() : this.languageCode,
    numeralStyle: numeralStyle ?? this.numeralStyle,
  );

  @override
  List<Object?> get props => [themeMode, languageCode, numeralStyle];
}
