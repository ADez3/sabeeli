import 'package:flutter/material.dart';

/// Raw colour values. Widgets never read these directly; they go through
/// [AppColors] (`context.colors`) so light and dark stay in one place.
///
/// The mood is "night sky over a courtyard": deep teal-black surfaces, a calm mint
/// primary, and a warm gold used sparingly for what is sacred or important (the
/// next prayer, surah headers, ayah markers).
abstract final class AppPalette {
  // Dark
  static const night = Color(0xFF081012);
  static const nightSurface = Color(0xFF0E1A1D);
  static const nightSurfaceHigh = Color(0xFF142428);
  static const nightSurfaceHighest = Color(0xFF1B2F34);
  static const nightOutline = Color(0xFF223A3F);
  static const mint = Color(0xFF5ED6BA);
  static const mintDeep = Color(0xFF1F8E78);
  static const gold = Color(0xFFE3BE74);
  static const goldDeep = Color(0xFFB38A3A);
  static const moonText = Color(0xFFE9F1EE);
  static const mistText = Color(0xFF8DA5A0);

  // Light
  static const parchment = Color(0xFFF7F4ED);
  static const paper = Color(0xFFFFFFFF);
  static const sand = Color(0xFFF0EBDF);
  static const sandHigh = Color(0xFFE8E1D1);
  static const sandOutline = Color(0xFFDDD5C2);
  static const teal = Color(0xFF0E6E5C);
  static const tealSoft = Color(0xFFD5EEE6);
  static const ink = Color(0xFF13201E);
  static const inkMuted = Color(0xFF5B6D69);

  static const danger = Color(0xFFE5736B);
}
