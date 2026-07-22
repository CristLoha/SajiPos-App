import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';
import 'package:saji_pos_app/features/discount/data/datasources/discount_remote_data_source.dart';

class DiscountRepositoryImpl implements DiscountRepository {
  final DiscountRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  DiscountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Discount>>> getActiveDiscounts({
    String? status,
    String? search,
  }) async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silakan login kembali.'),
        );
      }

      final remoteDiscounts = await remoteDataSource.getDiscounts(
        token,
        status: status,
        search: search,
      );
      final discountEntities = remoteDiscounts
          .map((model) => model.toEntity())
          .toList();

      return Right(discountEntities);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Gagal mengambil data diskon dari server'),
      );
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, Discount>> checkDiscountCode(String code) async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silakan login kembali.'),
        );
      }

      final remoteModel = await remoteDataSource.checkDiscountCode(token, code);
      return Right(remoteModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal memvalidasi kode promo'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }
}
