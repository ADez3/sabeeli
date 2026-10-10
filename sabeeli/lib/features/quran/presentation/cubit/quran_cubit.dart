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
    this.readPages = const {},
    this.failure,
  });

  final QuranStatus status;
  final QuranData? data;
  final List<Bookmark> bookmarks;
  final ReadingPosition? position;
  final ReaderPreferences preferences;

  /// Pages opened at least once, for the progress shown in the Quran sky.
  final Set<int> readPages;
  final Failure? failure;

  bool isBookmarked(AyahRef ref) => bookmarks.any((b) => b.ref == ref);

  QuranState copyWith({
    QuranStatus? status,
    QuranData? data,
    List<Bookmark>? bookmarks,
    ReadingPosition? Function()? position,
    ReaderPreferences? preferences,
    Set<int>? readPages,
    Failure? Function()? failure,
  }) => QuranState(
    status: status ?? this.status,
    data: data ?? this.data,
    bookmarks: bookmarks ?? this.bookmarks,
    position: position != null ? position() : this.position,
    preferences: preferences ?? this.preferences,
    readPages: readPages ?? this.readPages,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    data,
    bookmarks,
    position,
    preferences,
    readPages,
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
    this._readPages,
    this._markPageRead,
  ) : super(const QuranState());

  final LoadQuranUseCase _load;
  final GetBookmarksUseCase _bookmarks;
  final ToggleBookmarkUseCase _toggle;
  final GetReadingPositionUseCase _position;
  final SaveReadingPositionUseCase _savePosition;
  final GetReaderPreferencesUseCase _preferences;
  final SaveReaderPreferencesUseCase _savePreferences;
  final GetReadPagesUseCase _readPages;
  final MarkPageReadUseCase _markPageRead;

  /// The device's region (or the location's country): picks the riwayah until
  /// the user chooses one. Set by the shell's AppSync.
  String? _region;

  /// The riwayah to read: the user's choice, or the one of their region.
  Riwayah get riwayah =>
      state.preferences.riwayah ?? Riwayah.forCountry(_region);

  Future<void> load() async {
    if (state.status == QuranStatus.loading ||
        state.status == QuranStatus.ready) {
      return;
    }
    emit(state.copyWith(status: QuranStatus.loading));
    final preferences = (await _preferences(const NoParams())).valueOrNull;
    if (preferences != null) emit(state.copyWith(preferences: preferences));
    await _open(riwayah);
  }

  /// Loads a mushaf, then the personal state, which the repository converts
  /// into that mushaf's numbering.
  Future<void> _open(Riwayah riwayah) async {
    final result = await _load(riwayah);
    final data = result.valueOrNull;
    if (data == null) {
      result.fold(
        (failure) => emit(
          state.copyWith(status: QuranStatus.failed, failure: () => failure),
        ),
        (_) {},
      );
      return;
    }
    final bookmarks =
        (await _bookmarks(const NoParams())).valueOrNull ?? const [];
    final position = (await _position(const NoParams())).valueOrNull;
    final readPages = (await _readPages(const NoParams())).valueOrNull;
    emit(
      state.copyWith(
        status: QuranStatus.ready,
        data: data,
        bookmarks: bookmarks,
        position: () => position,
        readPages: readPages,
        failure: () => null,
      ),
    );
  }

  void setRegion(String? countryCode) {
    if (_region == countryCode) return;
    _region = countryCode;
    final data = state.data;
    if (state.status == QuranStatus.ready &&
        data != null &&
        data.riwayah != riwayah) {
      _open(riwayah);
    }
  }

  /// Null goes back to following the region.
  Future<void> setRiwayah(Riwayah? choice) async {
    await _setPreferences(state.preferences.copyWith(riwayah: () => choice));
    if (state.data?.riwayah != riwayah) await _open(riwayah);
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
    emit(state.copyWith(position: () => position));
    await _savePosition(position);
    // A page the reader settles on counts as read; it lights its surah's star.
    if (page != null && !state.readPages.contains(page)) {
      final result = await _markPageRead(page);
      result.fold((_) {}, (pages) => emit(state.copyWith(readPages: pages)));
    }
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
