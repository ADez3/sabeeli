import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dhikr_step.dart';
import '../../domain/usecases/get_after_prayer_steps_usecase.dart';

class DhikrSessionState extends Equatable {
  const DhikrSessionState({
    this.prayer,
    this.steps = const [],
    this.index = 0,
    this.counted = 0,
    this.failure,
  });

  /// The prayer just prayed, for the after-prayer adhkar; null otherwise.
  final Prayer? prayer;
  final List<DhikrStep> steps;

  /// The step being said; equal to `steps.length` once all are done.
  final int index;

  /// Repetitions of the current step said so far.
  final int counted;
  final Failure? failure;

  bool get loaded => steps.isNotEmpty;
  bool get finished => loaded && index >= steps.length;
  DhikrStep? get step => finished || !loaded ? null : steps[index];
  int get target => step?.countAfter(prayer) ?? 0;
  int get left => target - counted;

  /// Every repetition of the session, for the closing summary.
  int get totalRepetitions =>
      steps.fold(0, (sum, s) => sum + s.countAfter(prayer));

  DhikrSessionState copyWith({
    List<DhikrStep>? steps,
    int? index,
    int? counted,
    Failure? failure,
  }) => DhikrSessionState(
    prayer: prayer,
    steps: steps ?? this.steps,
    index: index ?? this.index,
    counted: counted ?? this.counted,
    failure: failure ?? this.failure,
  );

  @override
  List<Object?> get props => [prayer, steps, index, counted, failure];
}

/// Walks through adhkar one at a time, counting each step and moving on once
/// it has been said the right number of times.
@injectable
class DhikrSessionCubit extends Cubit<DhikrSessionState> {
  DhikrSessionCubit(this._steps) : super(const DhikrSessionState());

  final GetAfterPrayerStepsUseCase _steps;

  /// A session over given steps (a category of Hisn al-Muslim).
  void start(List<DhikrStep> steps) => emit(DhikrSessionState(steps: steps));

  /// The adhkar after [prayer].
  Future<void> loadAfterPrayer(Prayer prayer) async {
    emit(DhikrSessionState(prayer: prayer));
    final result = await _steps(prayer);
    result.fold(
      (f) => emit(state.copyWith(failure: f)),
      (steps) => emit(state.copyWith(steps: steps)),
    );
  }

  /// One repetition of the current step.
  void count() {
    if (state.step == null) return;
    final counted = state.counted + 1;
    if (counted >= state.target) {
      HapticFeedback.heavyImpact();
      emit(state.copyWith(index: state.index + 1, counted: 0));
    } else {
      HapticFeedback.selectionClick();
      emit(state.copyWith(counted: counted));
    }
  }

  void goTo(int index) {
    if (index < 0 || index > state.steps.length) return;
    HapticFeedback.selectionClick();
    emit(state.copyWith(index: index, counted: 0));
  }

  void restart() => emit(state.copyWith(index: 0, counted: 0));
}
