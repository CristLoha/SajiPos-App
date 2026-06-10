import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi telah berakhir. Silakan login kembali.'));
      }
      final productModels = await remoteDataSource.getProducts(token);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil data produk'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi telah berakhir. Silakan login kembali.'));
      }
      final productModels = await remoteDataSource.getProducts(token, search: query);
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
        return const Left(ServerFailure('Sesi telah berakhir. Silakan login kembali.'));
      }
      final productDetailModel = await remoteDataSource.getProductDetail(token, id);
      return Right(productDetailModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil detail produk'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }
}
