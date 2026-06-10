import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';
import 'package:saji_pos_app/features/product/domain/repositories/product_repository.dart';

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  Future<Either<Failure, List<Product>>> execute(){
    return repository.getProducts( );
  }
}