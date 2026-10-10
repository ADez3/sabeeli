import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);
  static ThemeData get light => _build(AppColors.light, Brightness.light);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.primary,
          brightness: brightness,
        ).copyWith(
          primary: c.primary,
          onPrimary: c.onPrimary,
          secondary: c.accent,
          surface: c.surface,
          onSurface: c.text,
          onSurfaceVariant: c.textMuted,
          surfaceContainerLowest: c.background,
          surfaceContainerLow: c.surface,
          surfaceContainer: c.surfaceHigh,
          surfaceContainerHigh: c.surfaceHigh,
          surfaceContainerHighest: c.surfaceHighest,
          outline: c.outline,
          outlineVariant: c.outline,
          error: c.danger,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.ui,
      fontFamilyFallback: AppFonts.uiFallback,
      scaffoldBackgroundColor: c.background,
      splashFactory: InkSparkle.splashFactory,
      extensions: [c],
    );

    final text = _textTheme(base.textTheme, c);

    return base.copyWith(
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: c.hairline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: c.primary.withValues(alpha: 0.16),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? c.primary : c.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => text.labelSmall?.copyWith(
            color: s.contains(WidgetState.selected) ? c.primary : c.textMuted,
            fontWeight: s.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.primary.withValues(alpha: 0.16),
        selectedIconTheme: IconThemeData(color: c.primary),
        unselectedIconTheme: IconThemeData(color: c.textMuted),
        selectedLabelTextStyle: text.labelMedium?.copyWith(
          color: c.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(
          color: c.textMuted,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.textMuted,
        textColor: c.text,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      dividerTheme: DividerThemeData(color: c.hairline, space: 1, thickness: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.textFaint.withValues(alpha: 0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const StadiumBorder(),
          textStyle: text.labelLarge?.copyWith(fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.text,
          minimumSize: const Size(0, 52),
          side: BorderSide(color: c.outline),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.primary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onPrimary : c.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? c.primary : c.surfaceHighest,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: c.primary.withValues(alpha: 0.16),
          selectedForegroundColor: c.primary,
          foregroundColor: c.textMuted,
          side: BorderSide(color: c.outline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceHigh,
        selectedColor: c.primary.withValues(alpha: 0.18),
        side: BorderSide(color: c.outline),
        labelStyle: text.labelMedium,
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceHighest,
        contentTextStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: c.primary,
        unselectedLabelColor: c.textMuted,
        indicatorColor: c.primary,
        dividerColor: Colors.transparent,
        labelStyle: text.titleSmall,
        unselectedLabelStyle: text.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.surfaceHighest,
        circularTrackColor: c.surfaceHighest,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.primary,
        inactiveTrackColor: c.surfaceHighest,
        thumbColor: c.primary,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Readex Pro for reading and controls; the Fraunces serif (with Reem Kufi for
  /// Arabic) for display sizes. Letter-spacing is zero throughout: any tracking
  /// breaks the joins of Arabic script.
  static TextTheme _textTheme(TextTheme base, AppColors c) {
    final t = base.apply(
      fontFamily: AppFonts.ui,
      fontFamilyFallback: AppFonts.uiFallback,
      bodyColor: c.text,
      displayColor: c.text,
    );
    TextStyle? flat(TextStyle? s, FontWeight w) =>
        s?.copyWith(letterSpacing: 0, fontWeight: w);
    TextStyle? serif(TextStyle? s, FontWeight w) => s?.copyWith(
      fontFamily: AppFonts.serif,
      fontFamilyFallback: AppFonts.displayFallback,
      fontWeight: w,
      letterSpacing: 0,
      height: 1.15,
    );
    return t.copyWith(
      displayLarge: serif(t.displayLarge, FontWeight.w300),
      displayMedium: serif(t.displayMedium, FontWeight.w300),
      displaySmall: serif(t.displaySmall, FontWeight.w300),
      headlineLarge: serif(t.headlineLarge, FontWeight.w300),
      headlineMedium: serif(t.headlineMedium, FontWeight.w300),
      headlineSmall: serif(t.headlineSmall, FontWeight.w500),
      titleLarge: flat(t.titleLarge, FontWeight.w500),
      titleMedium: flat(t.titleMedium, FontWeight.w500),
      titleSmall: flat(t.titleSmall, FontWeight.w500),
      bodyLarge: flat(t.bodyLarge, FontWeight.w400),
      bodyMedium: flat(t.bodyMedium, FontWeight.w400),
      bodySmall: flat(
        t.bodySmall,
        FontWeight.w400,
      )?.copyWith(color: c.textMuted),
      labelLarge: flat(t.labelLarge, FontWeight.w500),
      labelMedium: flat(t.labelMedium, FontWeight.w500),
      labelSmall: flat(t.labelSmall, FontWeight.w500),
    );
  }
}
