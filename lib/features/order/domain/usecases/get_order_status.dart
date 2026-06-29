import 'package:dartz/dartz.dart' hide Order;
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';
import 'package:saji_pos_app/features/order/domain/repositories/order_repository.dart';

class GetOrderStatus {
  final OrderRepository repository;
  GetOrderStatus(this.repository);
  Future<Either<Failure, Order>> call(int orderId) async {
    return await repository.getOrderStatus(orderId);
  }
}
