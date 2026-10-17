import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// The single list of UI languages. Adding a language is: add `intl_<code>.arb`, then
/// add an entry here with its name written in that language.
abstract final class L10n {
  static const languages = <({String code, String nativeName})>[
    (code: 'ar', nativeName: 'العربية'),
    (code: 'en', nativeName: 'English'),
    (code: 'fr', nativeName: 'Français'),
    (code: 'ur', nativeName: 'اردو'),
    (code: 'id', nativeName: 'Bahasa Indonesia'),
    (code: 'tr', nativeName: 'Türkçe'),
    (code: 'bn', nativeName: 'বাংলা'),
    (code: 'ms', nativeName: 'Bahasa Melayu'),
    (code: 'fa', nativeName: 'فارسی'),
    (code: 'ru', nativeName: 'Русский'),
    (code: 'de', nativeName: 'Deutsch'),
  ];

  static List<Locale> get all => AppLocalizations.supportedLocales;
}

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The language the UI is actually rendering in (after system fallback).
  String get languageCode => Localizations.localeOf(this).languageCode;
}
