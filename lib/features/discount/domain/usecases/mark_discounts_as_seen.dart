import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';

class MarkDiscountsAsSeen {
  final DiscountRepository repository;

  MarkDiscountsAsSeen(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.markDiscountsAsSeen();
  }
}
