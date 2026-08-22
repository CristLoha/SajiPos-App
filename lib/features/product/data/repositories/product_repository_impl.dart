import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource productLocalDataSource;
  final AuthLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.productLocalDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? search,
    int? categoryId,
  }) async {
    try {
      var cachedProducts = await productLocalDataSource.getCachedProducts();
      
      if (cachedProducts.isEmpty) {
        final syncResult = await syncProducts();
        if (syncResult.isRight()) {
           cachedProducts = await productLocalDataSource.getCachedProducts();
        } else {
           // If sync fails and cache is empty, return the sync error
           return Left(ServerFailure(syncResult.fold((l) => l.message, (r) => 'Error')));
        }
      }

      var filtered = cachedProducts;
      if (search != null && search.isNotEmpty) {
        filtered = filtered.where((p) => p.name.toLowerCase().contains(search.toLowerCase())).toList();
      }
      if (categoryId != null && categoryId > 0) {
        filtered = filtered.where((p) => p.categoryId == categoryId).toList();
      }

      final products = filtered.map((model) => model.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Gagal mengambil data lokal: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silakan login kembali.'),
        );
      }
      final productModels = await remoteDataSource.getProducts(
        token,
        search: query,
      );
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mencari produk'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(int id) async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silakan login kembali.'),
        );
      }
      final productDetailModel = await remoteDataSource.getProductDetail(
        token,
        id,
      );
      return Right(productDetailModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil detail produk'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> syncProducts() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silakan login kembali.'),
        );
      }
      // Get remote data
      final productModels = await remoteDataSource.getProducts(token);
      
      // Save to SQLite
      await productLocalDataSource.cacheProducts(productModels);
      
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal sinkronisasi data dari server'));
    } catch (e, stacktrace) {
      debugPrint('🔥 [SYNC ERROR]: $e');
      debugPrint('🔥 [STACKTRACE]: $stacktrace');
      return Left(ServerFailure('Gagal sinkronisasi produk: $e'));
    }
  }
}
