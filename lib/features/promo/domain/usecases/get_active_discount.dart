import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/promo/domain/entities/discount.dart';
import 'package:saji_pos_app/features/promo/domain/repositories/discount_repository.dart';

class GetActiveDiscount {
  final DiscountRepository repository;

  GetActiveDiscount(this.repository);

  Future<Either<Failure, List<Discount>>> call() async {
    return await repository.getActiveDiscounts();
  }
}
