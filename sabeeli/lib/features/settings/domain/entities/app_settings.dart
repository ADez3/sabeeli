import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../../../../core/utils/numerals.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.languageCode,
    this.numeralStyle = NumeralStyle.auto,
    this.onboarded = false,
    this.shakeToReport = true,
    this.betaNoticeSeen = false,
  });

  /// Dark is the default: the app is designed dark-first.
  final ThemeMode themeMode;

  /// Null follows the device language.
  final String? languageCode;

  /// Digits for every number in the app, Quran ayah numbers included.
  final NumeralStyle numeralStyle;

  /// The welcome has been seen (or skipped).
  final bool onboarded;

  /// Shaking the phone opens a problem report (beta).
  final bool shakeToReport;
  final bool betaNoticeSeen;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? Function()? languageCode,
    NumeralStyle? numeralStyle,
    bool? onboarded,
    bool? shakeToReport,
    bool? betaNoticeSeen,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    languageCode: languageCode != null ? languageCode() : this.languageCode,
    numeralStyle: numeralStyle ?? this.numeralStyle,
    onboarded: onboarded ?? this.onboarded,
    shakeToReport: shakeToReport ?? this.shakeToReport,
    betaNoticeSeen: betaNoticeSeen ?? this.betaNoticeSeen,
  );

  @override
  List<Object?> get props => [
    themeMode,
    languageCode,
    numeralStyle,
    onboarded,
    shakeToReport,
    betaNoticeSeen,
  ];
}
