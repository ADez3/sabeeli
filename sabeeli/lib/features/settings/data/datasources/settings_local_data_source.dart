import 'package:flutter/material.dart' show ThemeMode;
import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../../../core/utils/numerals.dart';
import '../../domain/entities/app_settings.dart';

@lazySingleton
class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._store);
  final KeyValueStore _store;

  static const _themeKey = 'settings.theme';
  static const _languageKey = 'settings.language';
  static const _numeralsKey = 'settings.numerals';

  AppSettings read() => AppSettings(
    themeMode:
        ThemeMode.values.asNameMap()[_store.getString(_themeKey)] ??
        ThemeMode.dark,
    languageCode: _store.getString(_languageKey),
    numeralStyle:
        NumeralStyle.values.asNameMap()[_store.getString(_numeralsKey)] ??
        NumeralStyle.auto,
  );

  Future<void> write(AppSettings settings) async {
    await _store.setString(_themeKey, settings.themeMode.name);
    await _store.setString(_numeralsKey, settings.numeralStyle.name);
    final code = settings.languageCode;
    if (code == null) {
      await _store.remove(_languageKey);
    } else {
      await _store.setString(_languageKey, code);
    }
  }
}
