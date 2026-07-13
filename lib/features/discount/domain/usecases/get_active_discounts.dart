import 'package:dartz/dartz.dart';

// Core
import 'package:saji_pos_app/core/error/failures.dart';

// Discount Feature (Domain)
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';

class GetActiveDiscounts {
  final DiscountRepository repository;

  GetActiveDiscounts(this.repository);

  Future<Either<Failure, List<Discount>>> call() async {
    return await repository.getActiveDiscounts();
  }
}
