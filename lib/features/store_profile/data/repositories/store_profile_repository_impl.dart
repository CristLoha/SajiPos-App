import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/store_profile.dart';
import '../../domain/repositories/store_profile_repository.dart';
import '../datasources/store_profile_remote_data_source.dart';

class StoreProfileRepositoryImpl implements StoreProfileRepository {
  final StoreProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  StoreProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, StoreProfile>> getStoreProfile() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi telah berakhir. Silakan login kembali.'));
      }
      final storeProfileModel = await remoteDataSource.getStoreProfile(token);
      return Right(storeProfileModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil profil toko'));
    } catch (e) {
      return Left(ServerFailure('Gagal mengambil profil toko: $e'));
    }
  }
}
