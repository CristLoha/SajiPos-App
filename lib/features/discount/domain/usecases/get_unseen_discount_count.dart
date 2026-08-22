import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';

class GetUnseenDiscountCount {
  final DiscountRepository repository;

  GetUnseenDiscountCount(this.repository);

  Future<Either<Failure, int>> call() async {
    return await repository.getUnseenDiscountCount();
  }
}
