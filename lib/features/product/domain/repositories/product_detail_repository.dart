import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_detail.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetail>> getProductDetail(int id);
}
