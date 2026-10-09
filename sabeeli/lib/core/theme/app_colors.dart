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
    required this.heroGradient,
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

  /// Behind the next-prayer card on the home screen.
  final List<Color> heroGradient;

  /// Page colour of the Quran reader, softer than [background] for long reading.
  final Color mushafPage;
  final Color ayahHighlight;
  final Color danger;

  static const dark = AppColors(
    background: AppPalette.night,
    surface: AppPalette.nightSurface,
    surfaceHigh: AppPalette.nightSurfaceHigh,
    surfaceHighest: AppPalette.nightSurfaceHighest,
    outline: AppPalette.nightOutline,
    primary: AppPalette.mint,
    onPrimary: AppPalette.night,
    accent: AppPalette.gold,
    text: AppPalette.moonText,
    textMuted: AppPalette.mistText,
    heroGradient: [Color(0xFF0F3A36), Color(0xFF0B2226), Color(0xFF081315)],
    mushafPage: Color(0xFF0B1517),
    ayahHighlight: Color(0x335ED6BA),
    danger: AppPalette.danger,
  );

  static const light = AppColors(
    background: AppPalette.parchment,
    surface: AppPalette.paper,
    surfaceHigh: AppPalette.sand,
    surfaceHighest: AppPalette.sandHigh,
    outline: AppPalette.sandOutline,
    primary: AppPalette.teal,
    onPrimary: Colors.white,
    accent: AppPalette.goldDeep,
    text: AppPalette.ink,
    textMuted: AppPalette.inkMuted,
    heroGradient: [Color(0xFF0E6E5C), Color(0xFF0B5548), Color(0xFF083E35)],
    mushafPage: Color(0xFFFBF8F0),
    ayahHighlight: Color(0x260E6E5C),
    danger: Color(0xFFC0473F),
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
      heroGradient: [
        for (var i = 0; i < heroGradient.length; i++)
          l(heroGradient[i], other.heroGradient[i]),
      ],
      mushafPage: l(mushafPage, other.mushafPage),
      ayahHighlight: l(ayahHighlight, other.ayahHighlight),
      danger: l(danger, other.danger),
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
