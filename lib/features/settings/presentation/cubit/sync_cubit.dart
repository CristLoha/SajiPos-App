import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:saji_pos_app/features/product/domain/usecases/sync_products.dart';
import 'package:saji_pos_app/features/order/domain/usecases/sync_pending_orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final int timestamp;
  
  SyncState({
    this.isLoading = false, 
    this.isSuccess = false, 
    this.message,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [isLoading, isSuccess, message, timestamp];
}

class SyncCubit extends Cubit<SyncState> {
  final SyncProducts syncProducts;
  final SyncPendingOrders syncPendingOrders;
  final SharedPreferences sharedPreferences;
  
  SyncCubit({
    required this.syncProducts, 
    required this.syncPendingOrders,
    required this.sharedPreferences
  }) : super(SyncState()) {
    _loadLastSyncTime();
  }

  void _loadLastSyncTime() {
    final lastSync = sharedPreferences.getString('last_sync_time');
    if (lastSync != null) {
      // Set isSuccess to false initially so the UI shows "Belum tersinkron"
      // until a successful sync is performed in the current session.
      emit(SyncState(isLoading: false, isSuccess: false, message: 'Terakhir sinkronisasi: $lastSync'));
    }
  }

  Future<void> syncData() async {
    emit(SyncState(isLoading: true));
    
    final startTime = DateTime.now();

    // Sync Products & Categories first
    final result = await syncProducts();
    
    // Sync Offline Orders (Second Striker)
    final orderResult = await syncPendingOrders();
    
    final elapsedTime = DateTime.now().difference(startTime);
    if (elapsedTime.inMilliseconds < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - elapsedTime.inMilliseconds));
    }

    result.fold(
      (failure) => emit(SyncState(isLoading: false, isSuccess: false, message: failure.message)),
      (success) async {
        String msg = '';
        orderResult.fold(
          (failure) => msg = '\n(Gagal kirim pesanan offline)',
          (syncedCount) {
            if (syncedCount > 0) msg = '\n($syncedCount pesanan offline terkirim)';
          }
        );
        
        final now = DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(DateTime.now());
        await sharedPreferences.setString('last_sync_time', now);
        emit(SyncState(isLoading: false, isSuccess: true, message: 'Terakhir sinkronisasi: $now$msg'));
      },
    );
  }
}
