import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Semantic colours that Material's [ColorScheme] has no slot for, read with
/// `context.colors`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.surfaceHighest,
    required this.outline,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.text,
    required this.textMuted,
    required this.mushafPage,
    required this.ayahHighlight,
    required this.danger,
  });

  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color surfaceHighest;
  final Color outline;
  final Color primary;
  final Color onPrimary;

  /// Gold: reserved for the sacred and the important. Use sparingly.
  final Color accent;
  final Color text;
  final Color textMuted;

  /// Page colour of the Quran reader, softer than [background] for long reading.
  final Color mushafPage;
  final Color ayahHighlight;
  final Color danger;

  static const dark = AppColors(
    background: AppPalette.ink,
    surface: AppPalette.inkSurface,
    surfaceHigh: AppPalette.inkSurfaceHigh,
    surfaceHighest: AppPalette.inkSurfaceHighest,
    outline: AppPalette.inkOutline,
    primary: AppPalette.moonlight,
    onPrimary: AppPalette.ink,
    accent: AppPalette.dawn,
    text: AppPalette.starText,
    textMuted: AppPalette.dustText,
    mushafPage: Color(0xFF0D1019),
    ayahHighlight: Color(0x339DB2FF),
    danger: AppPalette.danger,
  );

  static const light = AppColors(
    background: AppPalette.paper,
    surface: AppPalette.white,
    surfaceHigh: AppPalette.stone,
    surfaceHighest: AppPalette.stoneHigh,
    outline: AppPalette.stoneOutline,
    primary: AppPalette.indigo,
    onPrimary: Colors.white,
    accent: AppPalette.amber,
    text: AppPalette.inkText,
    textMuted: AppPalette.slateText,
    mushafPage: Color(0xFFFBFAF6),
    ayahHighlight: Color(0x223A4FD0),
    danger: Color(0xFFC8433B),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceHigh: l(surfaceHigh, other.surfaceHigh),
      surfaceHighest: l(surfaceHighest, other.surfaceHighest),
      outline: l(outline, other.outline),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      accent: l(accent, other.accent),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      mushafPage: l(mushafPage, other.mushafPage),
      ayahHighlight: l(ayahHighlight, other.ayahHighlight),
      danger: l(danger, other.danger),
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
