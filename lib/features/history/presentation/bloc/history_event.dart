part of 'history_bloc.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class GetHistoryEvent extends HistoryEvent {}

class SyncMidtransEvent extends HistoryEvent {
  final int orderId;

  const SyncMidtransEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}
