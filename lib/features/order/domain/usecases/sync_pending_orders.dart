import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../repositories/order_repository.dart';

class SyncPendingOrders {
  final OrderRepository repository;

  SyncPendingOrders(this.repository);

  Future<Either<Failure, int>> call() async {
    return await repository.syncPendingOrders();
  }
}
