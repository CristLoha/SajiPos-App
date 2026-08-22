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
        return const Left(ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'));
      }
      final productDetailModel = await remoteDataSource.getProductDetail(token, id);
      return Right(productDetailModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Detail produknya ngumpet nih, coba di-refresh.'));
    } catch (e) {
      return Left(ServerFailure('Mohon maaf, sistem sedang ada kendala. Coba lagi nanti ya.'));
    }
  }
}
