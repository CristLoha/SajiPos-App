import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cost_setting.dart';
import '../../domain/usecases/cost_setting_usecases.dart';

abstract class CostSettingEvent extends Equatable {
  const CostSettingEvent();
  @override
  List<Object?> get props => [];
}

class LoadCostSetting extends CostSettingEvent {}

class UpdateCostSettingEvent extends CostSettingEvent {
  final CostSetting costSetting;
  const UpdateCostSettingEvent(this.costSetting);
  @override
  List<Object?> get props => [costSetting];
}

class LoadCachedCostSetting extends CostSettingEvent {}

abstract class CostSettingState extends Equatable {
  const CostSettingState();
  @override
  List<Object?> get props => [];
}

class CostSettingInitial extends CostSettingState {}

class CostSettingLoading extends CostSettingState {}

class CostSettingLoaded extends CostSettingState {
  final CostSetting costSetting;
  const CostSettingLoaded(this.costSetting);
  @override
  List<Object?> get props => [costSetting];
}

class CostSettingError extends CostSettingState {
  final String message;
  const CostSettingError(this.message);
  @override
  List<Object?> get props => [message];
}

class CostSettingBloc extends Bloc<CostSettingEvent, CostSettingState> {
  final GetCostSetting getCostSetting;
  final UpdateCostSetting updateCostSetting;
  final GetCachedCostSetting getCachedCostSetting;

  CostSettingBloc({
    required this.getCostSetting,
    required this.updateCostSetting,
    required this.getCachedCostSetting,
  }) : super(CostSettingInitial()) {
    on<LoadCostSetting>(_onLoadCostSetting);
    on<UpdateCostSettingEvent>(_onUpdateCostSetting);
    on<LoadCachedCostSetting>(_onLoadCachedCostSetting);
  }

  Future<void> _onLoadCostSetting(
    LoadCostSetting event,
    Emitter<CostSettingState> emit,
  ) async {
    emit(CostSettingLoading());
    final result = await getCostSetting();
    result.fold(
      (failure) => emit(CostSettingError(failure.message)),
      (costSetting) => emit(CostSettingLoaded(costSetting)),
    );
  }

  Future<void> _onUpdateCostSetting(
    UpdateCostSettingEvent event,
    Emitter<CostSettingState> emit,
  ) async {
    emit(CostSettingLoading());
    final result = await updateCostSetting(event.costSetting);
    result.fold(
      (failure) => emit(CostSettingError(failure.message)),
      (costSetting) => emit(CostSettingLoaded(costSetting)),
    );
  }

  Future<void> _onLoadCachedCostSetting(
    LoadCachedCostSetting event,
    Emitter<CostSettingState> emit,
  ) async {
    final result = await getCachedCostSetting();
    result.fold(
      (failure) => emit(CostSettingError(failure.message)),
      (costSetting) => emit(CostSettingLoaded(costSetting)),
    );
  }
}
