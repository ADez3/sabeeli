import 'package:flutter/widgets.dart';

/// The user's choice in settings.
enum NumeralStyle { auto, western, arabicIndic, persian }

/// The digit shapes the UI is drawn with.
enum Numerals {
  /// 0123456789, used across the Maghreb and most of the world.
  western(0x30),

  /// ٠١٢٣٤٥٦٧٨٩, used in Egypt, the Levant, Iraq and the Gulf.
  arabicIndic(0x0660),

  /// ۰۱۲۳۴۵۶۷۸۹, used for Persian, Urdu and Pashto.
  persian(0x06F0);

  const Numerals(this._zero);
  final int _zero;

  static const _maghreb = {'MA', 'DZ', 'TN', 'LY', 'MR', 'EH'};
  static const _mashriq = {
    'EG',
    'SD',
    'SA',
    'AE',
    'QA',
    'BH',
    'KW',
    'OM',
    'YE',
    'IQ',
    'SY',
    'JO',
    'LB',
    'PS',
  };

  /// Resolves [style]; `auto` follows the language and the region, because Arabic
  /// readers in Morocco use Western digits while those in Egypt use Arabic-Indic.
  static Numerals resolve(
    NumeralStyle style, {
    required String languageCode,
    String? countryCode,
  }) {
    switch (style) {
      case NumeralStyle.western:
        return western;
      case NumeralStyle.arabicIndic:
        return arabicIndic;
      case NumeralStyle.persian:
        return persian;
      case NumeralStyle.auto:
        final country = countryCode?.toUpperCase();
        if (_maghreb.contains(country)) return western;
        if (languageCode == 'fa' ||
            languageCode == 'ur' ||
            languageCode == 'ps') {
          return persian;
        }
        if (languageCode == 'ar' && _mashriq.contains(country)) {
          return arabicIndic;
        }
        return western;
    }
  }

  /// Rewrites every digit in [text], whichever of the three systems it was in,
  /// with the signs that go with them: the percent sign (٪) and, between two
  /// digits, the decimal separator (٫). A full stop elsewhere is left alone.
  String apply(String text) {
    final runes = text.runes.toList();
    final arabic = this != western;
    final out = StringBuffer();
    for (var i = 0; i < runes.length; i++) {
      final c = runes[i];
      final value = _digitValue(c);
      if (value != null) {
        out.writeCharCode(_zero + value);
      } else if (c == _percent || c == _arabicPercent) {
        out.writeCharCode(arabic ? _arabicPercent : _percent);
      } else if ((c == _point || c == _arabicPoint) &&
          i > 0 &&
          i < runes.length - 1 &&
          _digitValue(runes[i - 1]) != null &&
          _digitValue(runes[i + 1]) != null) {
        out.writeCharCode(arabic ? _arabicPoint : _point);
      } else {
        out.writeCharCode(c);
      }
    }
    return out.toString();
  }

  static const _percent = 0x25;
  static const _arabicPercent = 0x066A;
  static const _point = 0x2E;
  static const _arabicPoint = 0x066B;

  static int? _digitValue(int c) {
    if (c >= 0x30 && c <= 0x39) return c - 0x30;
    if (c >= 0x0660 && c <= 0x0669) return c - 0x0660;
    if (c >= 0x06F0 && c <= 0x06F9) return c - 0x06F0;
    // Date formatting for Bengali (and Hindi) writes its own digits; they are
    // rewritten too, so every number on screen follows the user's choice.
    if (c >= 0x09E6 && c <= 0x09EF) return c - 0x09E6;
    if (c >= 0x0966 && c <= 0x096F) return c - 0x0966;
    return null;
  }
}

/// Provides the resolved [Numerals] to the widget tree.
class NumeralsScope extends InheritedWidget {
  const NumeralsScope({
    super.key,
    required this.numerals,
    required super.child,
  });

  final Numerals numerals;

  static Numerals of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NumeralsScope>()?.numerals ??
      Numerals.western;

  @override
  bool updateShouldNotify(NumeralsScope oldWidget) =>
      oldWidget.numerals != numerals;
}
