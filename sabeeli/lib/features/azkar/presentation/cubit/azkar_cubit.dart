import 'package:equatable/equatable.dart';
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
