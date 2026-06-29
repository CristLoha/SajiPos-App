import 'package:dartz/dartz.dart' hide Order;
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> submitOrder(OrderRequest request);
  Future<Either<Failure, Order>> getOrderStatus(int orderId);
}
