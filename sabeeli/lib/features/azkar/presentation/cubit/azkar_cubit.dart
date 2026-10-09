import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/azkar_entities.dart';
import '../../domain/usecases/get_azkar_categories_usecase.dart';

enum AzkarStatus { initial, loading, ready, failed }

class AzkarState extends Equatable {
  const AzkarState({
    this.status = AzkarStatus.initial,
    this.categories = const [],
    this.failure,
  });

  final AzkarStatus status;
  final List<AzkarCategory> categories;
  final Failure? failure;

  AzkarCategory? byId(int id) =>
      categories.where((c) => c.id == id).firstOrNull;
  AzkarCategory? byKey(String key) =>
      categories.where((c) => c.key == key).firstOrNull;

  @override
  List<Object?> get props => [status, categories, failure];
}

@lazySingleton
class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(this._get) : super(const AzkarState());

  final GetAzkarCategoriesUseCase _get;

  Future<void> load() async {
    if (state.status == AzkarStatus.ready ||
        state.status == AzkarStatus.loading) {
      return;
    }
    emit(const AzkarState(status: AzkarStatus.loading));
    final result = await _get(const NoParams());
    result.fold(
      (failure) =>
          emit(AzkarState(status: AzkarStatus.failed, failure: failure)),
      (categories) =>
          emit(AzkarState(status: AzkarStatus.ready, categories: categories)),
    );
  }
}

/// Remaining repetitions per dhikr while reading one category.
class AzkarSessionState extends Equatable {
  const AzkarSessionState({required this.remaining});

  final Map<int, int> remaining;

  int left(DhikrItem item) => remaining[item.id] ?? item.count;
  bool isDone(DhikrItem item) => left(item) == 0;

  @override
  List<Object?> get props => [remaining];
}

@injectable
class AzkarSessionCubit extends Cubit<AzkarSessionState> {
  AzkarSessionCubit() : super(const AzkarSessionState(remaining: {}));

  /// Returns true when this tap finished the item.
  bool count(DhikrItem item) {
    final left = state.left(item);
    if (left == 0) return false;
    final next = left - 1;
    emit(AzkarSessionState(remaining: {...state.remaining, item.id: next}));
    next == 0 ? HapticFeedback.mediumImpact() : HapticFeedback.selectionClick();
    return next == 0;
  }

  void restart() => emit(const AzkarSessionState(remaining: {}));
}
