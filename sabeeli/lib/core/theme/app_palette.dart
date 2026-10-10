import 'package:flutter/material.dart';

/// Raw colour values. Widgets never read these directly; they go through
/// [AppColors] (`context.colors`) so light and dark stay in one place.
///
/// The mood is the sky between night and dawn: deep blue-black surfaces, a
/// moonlight primary, a twilight lavender, and a warm dawn amber kept for what
/// is sacred or matters most. In light mode the same roles sit on warm paper.
abstract final class AppPalette {
  // Dark: night
  static const night = Color(0xFF0A0E1A);
  static const nightSurface = Color(0xFF11162A);
  static const nightRaised = Color(0xFF171D36);
  static const nightHighest = Color(0xFF1F2642);
  static const nightHairline = Color(0x14FFFFFF);
  static const moonlight = Color(0xFFA9C2FF);
  static const twilight = Color(0xFFB7A8F0);
  static const dawn = Color(0xFFF4B56A);
  static const dawnRose = Color(0xFFF2A9A0);
  static const mint = Color(0xFF8FD3C1);
  static const starText = Color(0xFFEEF1F8);
  static const mistText = Color(0xFFA6AEC6);
  static const dimText = Color(0xFF6E7693);
  static const nightDanger = Color(0xFFFF8A8A);

  // Light: paper dawn
  static const paper = Color(0xFFF6F3EE);
  static const white = Color(0xFFFFFFFF);
  static const paperRaised = Color(0xFFFBF8F4);
  static const paperSunken = Color(0xFFEEE9E2);
  static const paperHairline = Color(0x14141A2E);
  static const indigo = Color(0xFF3A57D6);
  static const violet = Color(0xFF6B5BC4);
  static const amber = Color(0xFFB8661E);
  static const rose = Color(0xFFD9776B);
  static const teal = Color(0xFF2F8F7A);
  static const inkText = Color(0xFF141A2E);
  static const slateText = Color(0xFF4C5470);
  static const greyText = Color(0xFF828AA3);
  static const paperDanger = Color(0xFFC53A3A);
}
