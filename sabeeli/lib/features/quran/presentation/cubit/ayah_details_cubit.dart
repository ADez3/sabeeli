import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/quran_asset_data_source.dart';
import '../../domain/entities/quran_entities.dart';
import '../../domain/usecases/quran_usecases.dart';

class AyahDetailsState extends Equatable {
  const AyahDetailsState({
    this.tafsir,
    this.editions = const [],
    this.translation,
    this.translationText,
    this.translationMissing = false,
    this.downloading = false,
    this.failure,
  });

  /// Tafsir al-Muyassar, always available offline.
  final String? tafsir;
  final List<QuranEdition> editions;
  final QuranEdition? translation;
  final String? translationText;

  /// The chosen translation is not downloaded yet.
  final bool translationMissing;
  final bool downloading;
  final Failure? failure;

  AyahDetailsState copyWith({
    String? tafsir,
    List<QuranEdition>? editions,
    QuranEdition? Function()? translation,
    String? Function()? translationText,
    bool? translationMissing,
    bool? downloading,
    Failure? Function()? failure,
  }) => AyahDetailsState(
    tafsir: tafsir ?? this.tafsir,
    editions: editions ?? this.editions,
    translation: translation != null ? translation() : this.translation,
    translationText: translationText != null
        ? translationText()
        : this.translationText,
    translationMissing: translationMissing ?? this.translationMissing,
    downloading: downloading ?? this.downloading,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    tafsir,
    editions,
    translation,
    translationText,
    translationMissing,
    downloading,
    failure,
  ];
}

/// Tafsir and translation of one ayah, for the sheet opened by tapping it.
@injectable
class AyahDetailsCubit extends Cubit<AyahDetailsState> {
  AyahDetailsCubit(this._editions, this._text, this._download)
    : super(const AyahDetailsState());

  final GetEditionsUseCase _editions;
  final GetEditionTextUseCase _text;
  final DownloadEditionUseCase _download;

  late AyahRef _ref;

  /// [preferredId] is the user's saved choice; without one, a translation in
  /// [languageCode] is picked, and Arabic readers get the tafsir alone.
  Future<void> load(
    AyahRef ref, {
    String? preferredId,
    required String languageCode,
  }) async {
    _ref = ref;
    final editions =
        (await _editions(const NoParams())).valueOrNull ?? const [];
    final tafsirEdition = editions.firstWhere(
      (e) => e.id == QuranAssetDataSource.tafsirMuyassarId,
    );
    final tafsir = (await _text(EditionTextParams(tafsirEdition, ref)))
        .valueOrNull;

    final translations = editions
        .where((e) => e.id != tafsirEdition.id)
        .toList();
    QuranEdition? chosen;
    if (preferredId != null) {
      chosen = translations.where((e) => e.id == preferredId).firstOrNull;
    } else if (languageCode != 'ar') {
      chosen =
          translations
              .where((e) => e.languageCode == languageCode && !e.isTafsir)
              .firstOrNull ??
          translations.firstWhere(
            (e) => e.id == QuranAssetDataSource.englishSahihId,
          );
    }
    emit(state.copyWith(tafsir: tafsir, editions: translations));
    await _show(chosen);
  }

  Future<void> select(QuranEdition? edition) => _show(edition);

  Future<void> download() async {
    final edition = state.translation;
    if (edition == null) return;
    emit(state.copyWith(downloading: true, failure: () => null));
    final result = await _download(edition);
    result.fold(
      (failure) =>
          emit(state.copyWith(downloading: false, failure: () => failure)),
      (_) async {
        emit(state.copyWith(downloading: false));
        await _show(edition);
      },
    );
  }

  Future<void> _show(QuranEdition? edition) async {
    if (edition == null) {
      emit(
        state.copyWith(
          translation: () => null,
          translationText: () => null,
          translationMissing: false,
        ),
      );
      return;
    }
    final text = (await _text(EditionTextParams(edition, _ref))).valueOrNull;
    emit(
      state.copyWith(
        translation: () => edition,
        translationText: () => text,
        translationMissing: text == null,
      ),
    );
  }
}
