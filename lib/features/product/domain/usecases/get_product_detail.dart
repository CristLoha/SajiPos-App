import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_detail.dart';
import '../repositories/product_detail_repository.dart';

class GetProductDetail {
  final ProductDetailRepository repository;

  GetProductDetail(this.repository);

  Future<Either<Failure, ProductDetail>> execute(int id) {
    return repository.getProductDetail(id);
  }
}
