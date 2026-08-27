import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/product/domain/repositories/product_repository.dart';

import 'package:saji_pos_app/features/category/domain/repositories/category_repository.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';

class SyncProducts {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;
  final DiscountRepository discountRepository;

  SyncProducts(
    this.productRepository,
    this.categoryRepository,
    this.discountRepository,
  );

  Future<Either<Failure, bool>> call() async {
    final catSync = await categoryRepository.syncCategories();
    if (catSync.isLeft()) return catSync;

    final discSync = await discountRepository.syncDiscounts();
    if (discSync.isLeft()) return discSync;

    final prodSync = await productRepository.syncProducts();
    if (prodSync.isLeft()) return prodSync;

    return const Right(true);
  }
}
