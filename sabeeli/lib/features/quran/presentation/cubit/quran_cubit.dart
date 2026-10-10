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
    this.readDays = const {},
    this.plan,
    this.failure,
  });

  final QuranStatus status;
  final QuranData? data;
  final List<Bookmark> bookmarks;
  final ReadingPosition? position;
  final ReaderPreferences preferences;

  /// Pages opened at least once, for the progress shown in the Quran sky.
  final Set<int> readPages;

  /// Local dates on which a page was read, for the weekly line.
  final Set<DateTime> readDays;

  /// The khatmah plan in progress, if any.
  final KhatmahPlan? plan;
  final Failure? failure;

  /// Days read among the last seven, today included.
  int readDaysThisWeek(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return readDays
        .where((d) => !d.isAfter(today) && today.difference(d).inDays < 7)
        .length;
  }

  bool isBookmarked(AyahRef ref) => bookmarks.any((b) => b.ref == ref);

  QuranState copyWith({
    QuranStatus? status,
    QuranData? data,
    List<Bookmark>? bookmarks,
    ReadingPosition? Function()? position,
    ReaderPreferences? preferences,
    Set<int>? readPages,
    Set<DateTime>? readDays,
    KhatmahPlan? Function()? plan,
    Failure? Function()? failure,
  }) => QuranState(
    status: status ?? this.status,
    data: data ?? this.data,
    bookmarks: bookmarks ?? this.bookmarks,
    position: position != null ? position() : this.position,
    preferences: preferences ?? this.preferences,
    readPages: readPages ?? this.readPages,
    readDays: readDays ?? this.readDays,
    plan: plan != null ? plan() : this.plan,
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
    readDays,
    plan,
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
    this._readDays,
    this._plan,
    this._savePlan,
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
  final GetReadDaysUseCase _readDays;
  final GetKhatmahPlanUseCase _plan;
  final SaveKhatmahPlanUseCase _savePlan;

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
    final readDays = (await _readDays(const NoParams())).valueOrNull;
    final plan = (await _plan(const NoParams())).valueOrNull;
    emit(
      state.copyWith(
        status: QuranStatus.ready,
        data: data,
        bookmarks: bookmarks,
        position: () => position,
        readPages: readPages,
        readDays: readDays,
        plan: () => plan,
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
    if (page != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (!state.readPages.contains(page) || !state.readDays.contains(today)) {
        final result = await _markPageRead(page);
        result.fold(
          (_) {},
          (pages) => emit(
            state.copyWith(
              readPages: pages,
              readDays: {...state.readDays, today},
            ),
          ),
        );
      }
    }
  }

  Future<void> setFontScale(double scale) => _setPreferences(
    state.preferences.copyWith(fontScale: scale.clamp(0.8, 1.8)),
  );

  /// Starts a khatmah plan today, or ends the current one with null.
  Future<void> setPlan(KhatmahPlan? plan) async {
    emit(state.copyWith(plan: () => plan));
    await _savePlan(plan);
  }

  Future<void> setReaderTheme(ReaderTheme theme) =>
      _setPreferences(state.preferences.copyWith(theme: theme));

  Future<void> setTranslation(String? id) =>
      _setPreferences(state.preferences.copyWith(translationId: () => id));

  Future<void> _setPreferences(ReaderPreferences p) async {
    emit(state.copyWith(preferences: p));
    await _savePreferences(p);
  }
}
