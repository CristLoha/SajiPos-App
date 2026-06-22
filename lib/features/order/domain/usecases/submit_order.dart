import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';
import 'package:saji_pos_app/features/order/domain/repositories/order_repository.dart';

class SubmitOrder {
  final OrderRepository repository;
  SubmitOrder(this.repository);
  Future<Either<Failure, bool>> call(OrderRequest request) async {
    return await repository.submitOrder(request);
  }
}
