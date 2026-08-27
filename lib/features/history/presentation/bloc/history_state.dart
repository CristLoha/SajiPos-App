part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();
  
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<TransactionEntity> transactions;

  const HistoryLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class HistorySyncing extends HistoryState {
  final List<TransactionEntity> transactions;
  final int syncingOrderId;
  const HistorySyncing(this.transactions, this.syncingOrderId);
  @override
  List<Object> get props => [transactions, syncingOrderId];
}

class HistorySyncSuccess extends HistoryState {
  final List<TransactionEntity> transactions;
  final String message;
  const HistorySyncSuccess(this.transactions, this.message);
  @override
  List<Object> get props => [transactions, message];
}

class HistorySyncError extends HistoryState {
  final List<TransactionEntity> transactions;
  final String message;
  const HistorySyncError(this.transactions, this.message);
  @override
  List<Object> get props => [transactions, message];
}
