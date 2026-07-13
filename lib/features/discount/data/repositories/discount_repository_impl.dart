import 'package:dartz/dartz.dart';

// Core
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';

// Auth Feature
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';

// Discount Feature (Domain)
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';

// Discount Feature (Data)
import 'package:saji_pos_app/features/discount/data/datasources/discount_remote_data_source.dart';

class DiscountRepositoryImpl implements DiscountRepository {
  final DiscountRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  DiscountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Discount>>> getActiveDiscounts() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi telah berakhir. Silakan login kembali.'),
        );
      }
      
      final remoteDiscounts = await remoteDataSource.getActiveDiscounts(token);
      final discountEntities = remoteDiscounts.map((model) => model.toEntity()).toList();
      
      return Right(discountEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil data diskon dari server'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }
}
