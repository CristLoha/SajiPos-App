import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';

abstract class DiscountRepository {
  Future<Either<Failure, List<Discount>>> getActiveDiscounts({
    String? status,
    String? search,
  });
  Future<Either<Failure, Discount>> checkDiscountCode(String code);
}
