import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/sync_midtrans_status.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetTransactions getTransactions;
  final SyncMidtransStatus syncMidtransStatus;

  HistoryBloc({required this.getTransactions, required this.syncMidtransStatus}) : super(HistoryInitial()) {
    on<GetHistoryEvent>((event, emit) async {
      emit(HistoryLoading());
      
      final result = await getTransactions();
      
      result.fold(
        (failure) => emit(HistoryError(failure.message)),
        (transactions) => emit(HistoryLoaded(transactions)),
      );
    });

    on<SyncMidtransEvent>((event, emit) async {
      List<TransactionEntity> currentData = [];
      if (state is HistoryLoaded) {
        currentData = (state as HistoryLoaded).transactions;
      } else if (state is HistorySyncing) {
        currentData = (state as HistorySyncing).transactions;
      } else if (state is HistorySyncSuccess) {
        currentData = (state as HistorySyncSuccess).transactions;
      } else if (state is HistorySyncError) {
        currentData = (state as HistorySyncError).transactions;
      }
      
      emit(HistorySyncing(currentData, event.orderId));
      
      final result = await syncMidtransStatus(event.orderId);
      
      result.fold(
        (failure) => emit(HistorySyncError(currentData, failure.message)),
        (_) {
          emit(HistorySyncSuccess(currentData, "Status berhasil diperbarui"));
          add(GetHistoryEvent()); // refetch after success
        },
      );
    });
  }
}
