import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_detail_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ProductDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
