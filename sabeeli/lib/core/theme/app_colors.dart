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
    required this.secondary,
    required this.rose,
    required this.success,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.hairline,
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

  /// Dawn amber: reserved for the sacred and the important. Use sparingly.
  final Color accent;

  /// Twilight lavender: a second hue for skies, auroras and quiet highlights.
  final Color secondary;

  /// Dawn rose: only in sky gradients and sky-related highlights.
  final Color rose;

  /// Something completed (a finished round, a read surah). Cool, not emerald.
  final Color success;
  final Color text;
  final Color textMuted;

  /// Tertiary text: captions, hints, disabled labels.
  final Color textFaint;

  /// 1 px separators and card rims.
  final Color hairline;

  /// Page colour of the Quran reader, softer than [background] for long reading.
  final Color mushafPage;
  final Color ayahHighlight;
  final Color danger;

  static const dark = AppColors(
    background: AppPalette.night,
    surface: AppPalette.nightSurface,
    surfaceHigh: AppPalette.nightRaised,
    surfaceHighest: AppPalette.nightHighest,
    outline: Color(0xFF262D4A),
    primary: AppPalette.moonlight,
    onPrimary: AppPalette.night,
    accent: AppPalette.dawn,
    secondary: AppPalette.twilight,
    rose: AppPalette.dawnRose,
    success: AppPalette.mint,
    text: AppPalette.starText,
    textMuted: AppPalette.mistText,
    textFaint: AppPalette.dimText,
    hairline: AppPalette.nightHairline,
    mushafPage: Color(0xFF0C1020),
    ayahHighlight: Color(0x33A9C2FF),
    danger: AppPalette.nightDanger,
  );

  static const light = AppColors(
    background: AppPalette.paper,
    surface: AppPalette.white,
    surfaceHigh: AppPalette.paperRaised,
    surfaceHighest: AppPalette.paperSunken,
    outline: Color(0xFFE2DCD2),
    primary: AppPalette.indigo,
    onPrimary: Colors.white,
    accent: AppPalette.amber,
    secondary: AppPalette.violet,
    rose: AppPalette.rose,
    success: AppPalette.teal,
    text: AppPalette.inkText,
    textMuted: AppPalette.slateText,
    textFaint: AppPalette.greyText,
    hairline: AppPalette.paperHairline,
    mushafPage: Color(0xFFFBF8F2),
    ayahHighlight: Color(0x223A57D6),
    danger: AppPalette.paperDanger,
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
      secondary: l(secondary, other.secondary),
      rose: l(rose, other.rose),
      success: l(success, other.success),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      textFaint: l(textFaint, other.textFaint),
      hairline: l(hairline, other.hairline),
      mushafPage: l(mushafPage, other.mushafPage),
      ayahHighlight: l(ayahHighlight, other.ayahHighlight),
      danger: l(danger, other.danger),
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
