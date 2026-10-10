import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/quran_entities.dart';

/// The colours of the mushaf page, independent of the app's theme: a night
/// page, warm sepia for long reading, or white paper.
extension ReaderThemeColors on ReaderTheme {
  /// [ReaderTheme.auto] follows the app: night in dark mode, paper in light.
  ReaderTheme resolve(Brightness app) => this != ReaderTheme.auto
      ? this
      : (app == Brightness.dark ? ReaderTheme.night : ReaderTheme.paper);

  Brightness get brightness =>
      this == ReaderTheme.night ? Brightness.dark : Brightness.light;

  /// The app's colours with the page's own text, ink and highlight.
  AppColors applyTo(AppColors base) {
    final (page, text, muted, accent, primary, outline) = switch (this) {
      ReaderTheme.sepia => (
        const Color(0xFFF3EAD7),
        const Color(0xFF3A2E1F),
        const Color(0xFF8A7558),
        const Color(0xFFA8641C),
        const Color(0xFF8A5A2B),
        const Color(0xFFDCCDB0),
      ),
      ReaderTheme.paper => (
        const Color(0xFFFBF8F2),
        const Color(0xFF141A2E),
        const Color(0xFF6B7186),
        const Color(0xFFB8661E),
        const Color(0xFF3A57D6),
        const Color(0xFFE5DFD3),
      ),
      _ => (
        const Color(0xFF0C1020),
        const Color(0xFFE9ECF5),
        const Color(0xFF8A93AE),
        const Color(0xFFF4B56A),
        const Color(0xFFA9C2FF),
        const Color(0xFF262D4A),
      ),
    };
    return AppColors(
      background: page,
      surface: base.surface,
      surfaceHigh: base.surfaceHigh,
      surfaceHighest: base.surfaceHighest,
      outline: outline,
      primary: primary,
      onPrimary: base.onPrimary,
      accent: accent,
      secondary: base.secondary,
      rose: base.rose,
      success: base.success,
      text: text,
      textMuted: muted,
      textFaint: muted.withValues(alpha: 0.7),
      hairline: text.withValues(alpha: 0.08),
      mushafPage: page,
      ayahHighlight: primary.withValues(alpha: 0.16),
      danger: base.danger,
    );
  }
}
