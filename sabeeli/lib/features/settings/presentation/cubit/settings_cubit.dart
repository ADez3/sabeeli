import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/numerals.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/settings_usecases.dart';

/// App-wide appearance and language. Provided above [MaterialApp] so a change
/// re-themes and re-localizes the whole tree at once.
@lazySingleton
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._load, this._save) : super(const AppSettings());

  final LoadAppSettingsUseCase _load;
  final SaveAppSettingsUseCase _save;

  /// Awaited before the first frame so the stored theme is used from the start.
  Future<void> load() async {
    final result = await _load(const NoParams());
    result.fold((_) {}, emit);
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  Future<void> setLanguage(String? code) =>
      _update(state.copyWith(languageCode: () => code));

  Future<void> setNumeralStyle(NumeralStyle style) =>
      _update(state.copyWith(numeralStyle: style));

  Future<void> completeOnboarding() => _update(state.copyWith(onboarded: true));

  Future<void> setShakeToReport(bool on) =>
      _update(state.copyWith(shakeToReport: on));

  Future<void> markBetaNoticeSeen() =>
      _update(state.copyWith(betaNoticeSeen: true));

  Future<void> _update(AppSettings next) async {
    emit(next);
    await _save(next);
  }
}
