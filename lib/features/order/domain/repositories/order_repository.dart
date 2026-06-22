import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';

abstract class OrderRepository {
  Future<Either<Failure, bool>> submitOrder(OrderRequest request);
}
