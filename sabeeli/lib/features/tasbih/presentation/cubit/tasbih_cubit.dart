import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/tasbih_state_data.dart';
import '../../domain/usecases/tasbih_usecases.dart';

@injectable
class TasbihCubit extends Cubit<TasbihData> {
  TasbihCubit(this._load, this._save) : super(const TasbihData());

  final LoadTasbihUseCase _load;
  final SaveTasbihUseCase _save;
  Timer? _debounce;

  Future<void> load() async {
    final result = await _load(const NoParams());
    result.fold((_) {}, emit);
  }

  void increment() {
    final s = state;
    var count = s.count + 1;
    var rounds = s.rounds;
    final completedRound = s.target > 0 && count >= s.target;
    if (completedRound) {
      count = 0;
      rounds++;
    }
    if (s.vibrate) {
      // A heavier pulse at the end of a round, so the count can be kept by feel.
      completedRound
          ? HapticFeedback.heavyImpact()
          : HapticFeedback.selectionClick();
    }
    _set(
      s.copyWith(
        count: count,
        rounds: rounds,
        totals: {...s.totals, s.dhikrId: s.total + 1},
      ),
    );
  }

  void reset() => _set(state.copyWith(count: 0, rounds: 0));

  void selectDhikr(String id) =>
      _set(state.copyWith(dhikrId: id, count: 0, rounds: 0));

  void setTarget(int target) =>
      _set(state.copyWith(target: target, count: 0, rounds: 0));

  void toggleVibration() => _set(state.copyWith(vibrate: !state.vibrate));

  /// Taps can come several per second; storage is written once they pause.
  void _set(TasbihData next) {
    emit(next);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () => _save(next));
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _save(state);
    return super.close();
  }
}
