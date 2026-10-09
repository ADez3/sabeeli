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

  /// Rewrites every digit in [text], whichever of the three systems it was in.
  String apply(String text) {
    final out = StringBuffer();
    for (final c in text.runes) {
      final value = _digitValue(c);
      out.writeCharCode(value == null ? c : _zero + value);
    }
    return out.toString();
  }

  static int? _digitValue(int c) {
    if (c >= 0x30 && c <= 0x39) return c - 0x30;
    if (c >= 0x0660 && c <= 0x0669) return c - 0x0660;
    if (c >= 0x06F0 && c <= 0x06F9) return c - 0x06F0;
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
