import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../repositories/history_repository.dart';

class SyncMidtransStatus {
  final HistoryRepository repository;

  SyncMidtransStatus(this.repository);

  Future<Either<Failure, void>> call(int orderId) {
    return repository.syncMidtransStatus(orderId);
  }
}
