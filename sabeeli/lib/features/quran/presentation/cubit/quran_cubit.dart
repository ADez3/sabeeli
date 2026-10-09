import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/quran_entities.dart';
import '../../domain/usecases/quran_usecases.dart';

enum QuranStatus { initial, loading, ready, failed }

class QuranState extends Equatable {
  const QuranState({
    this.status = QuranStatus.initial,
    this.data,
    this.bookmarks = const [],
    this.position,
    this.preferences = const ReaderPreferences(),
    this.failure,
  });

  final QuranStatus status;
  final QuranData? data;
  final List<Bookmark> bookmarks;
  final ReadingPosition? position;
  final ReaderPreferences preferences;
  final Failure? failure;

  bool isBookmarked(AyahRef ref) => bookmarks.any((b) => b.ref == ref);

  QuranState copyWith({
    QuranStatus? status,
    QuranData? data,
    List<Bookmark>? bookmarks,
    ReadingPosition? position,
    ReaderPreferences? preferences,
    Failure? Function()? failure,
  }) => QuranState(
    status: status ?? this.status,
    data: data ?? this.data,
    bookmarks: bookmarks ?? this.bookmarks,
    position: position ?? this.position,
    preferences: preferences ?? this.preferences,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    data,
    bookmarks,
    position,
    preferences,
    failure,
  ];
}

/// The mushaf plus the reader's personal state. App-wide so the home screen's
/// "continue reading" and the reader share one source of truth.
@lazySingleton
class QuranCubit extends Cubit<QuranState> {
  QuranCubit(
    this._load,
    this._bookmarks,
    this._toggle,
    this._position,
    this._savePosition,
    this._preferences,
    this._savePreferences,
  ) : super(const QuranState());

  final LoadQuranUseCase _load;
  final GetBookmarksUseCase _bookmarks;
  final ToggleBookmarkUseCase _toggle;
  final GetReadingPositionUseCase _position;
  final SaveReadingPositionUseCase _savePosition;
  final GetReaderPreferencesUseCase _preferences;
  final SaveReaderPreferencesUseCase _savePreferences;

  Future<void> load() async {
    if (state.status == QuranStatus.loading ||
        state.status == QuranStatus.ready) {
      return;
    }
    emit(state.copyWith(status: QuranStatus.loading));
    final bookmarks =
        (await _bookmarks(const NoParams())).valueOrNull ?? const [];
    final position = (await _position(const NoParams())).valueOrNull;
    final preferences = (await _preferences(const NoParams())).valueOrNull;
    emit(
      state.copyWith(
        bookmarks: bookmarks,
        position: position,
        preferences: preferences,
      ),
    );

    final result = await _load(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: QuranStatus.failed, failure: () => failure),
      ),
      (data) => emit(
        state.copyWith(
          status: QuranStatus.ready,
          data: data,
          failure: () => null,
        ),
      ),
    );
  }

  Future<void> toggleBookmark(AyahRef ref) async {
    final result = await _toggle(ref);
    result.fold((_) {}, (list) => emit(state.copyWith(bookmarks: list)));
  }

  /// Saved automatically as pages turn, and explicitly from the ayah sheet.
  Future<void> savePosition(AyahRef ref, {int? page}) async {
    final data = state.data;
    if (data == null) return;
    final position = ReadingPosition(
      ref: ref,
      page: page ?? data.pageOf(ref),
      updatedAt: DateTime.now(),
    );
    emit(state.copyWith(position: position));
    await _savePosition(position);
  }

  Future<void> setFontScale(double scale) => _setPreferences(
    state.preferences.copyWith(fontScale: scale.clamp(0.8, 1.8)),
  );

  Future<void> setTranslation(String? id) =>
      _setPreferences(state.preferences.copyWith(translationId: () => id));

  Future<void> _setPreferences(ReaderPreferences p) async {
    emit(state.copyWith(preferences: p));
    await _savePreferences(p);
  }
}
