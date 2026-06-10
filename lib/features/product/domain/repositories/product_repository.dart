import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';

abstract class ProductRepository {

  Future<Either<Failure, List<Product>>> getProducts(String token);
  Future<Either<Failure, 

}
