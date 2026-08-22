import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/features/product/domain/entities/product_detail.dart';
import '../../../../core/error/failures.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    String? search,
    int? categoryId,
  });
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, ProductDetail>> getProductDetail(int id);
  Future<Either<Failure, bool>> syncProducts();
}
