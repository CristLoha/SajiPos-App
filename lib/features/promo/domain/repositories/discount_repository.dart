import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/promo/domain/entities/discount.dart';

abstract class DiscountRepository {
  Future<Either<Failure, List<Discount>>> getActiveDiscounts();
}
