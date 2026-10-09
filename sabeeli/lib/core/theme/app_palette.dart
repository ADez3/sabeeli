import 'package:flutter/material.dart';

/// Raw colour values. Widgets never read these directly; they go through
/// [AppColors] (`context.colors`) so light and dark stay in one place.
///
/// The mood is the sky before dawn: ink-blue surfaces, a soft moonlight primary and
/// a warm amber kept for what matters most (the next prayer, sacred headings).
abstract final class AppPalette {
  // Dark
  static const ink = Color(0xFF0A0C14);
  static const inkSurface = Color(0xFF11141F);
  static const inkSurfaceHigh = Color(0xFF171B29);
  static const inkSurfaceHighest = Color(0xFF1F2435);
  static const inkOutline = Color(0xFF272C40);
  static const moonlight = Color(0xFF9DB2FF);
  static const dawn = Color(0xFFF4B860);
  static const starText = Color(0xFFECEEF6);
  static const dustText = Color(0xFF8A90A6);

  // Light
  static const paper = Color(0xFFF6F5F2);
  static const white = Color(0xFFFFFFFF);
  static const stone = Color(0xFFEFEEEA);
  static const stoneHigh = Color(0xFFE6E4DF);
  static const stoneOutline = Color(0xFFDEDBD3);
  static const indigo = Color(0xFF3A4FD0);
  static const amber = Color(0xFFC07A24);
  static const inkText = Color(0xFF161A26);
  static const slateText = Color(0xFF5F6474);

  static const danger = Color(0xFFEF7A72);
}
