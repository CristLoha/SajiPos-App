import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';

class GetActiveDiscount {
  final DiscountRepository repository;

  GetActiveDiscount(this.repository);

  Future<Either<Failure, List<Discount>>> call() async {
    return await repository.getActiveDiscounts();
  }
}
