import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saji_pos_app/features/auth/domain/entities/auth.dart';
import 'package:saji_pos_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Auth>> login({
    required String email,
    required String password,
  }) async {
    try {
      final remoteAuth = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveToken(remoteAuth.token);

      return Right(remoteAuth.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Yah login gagal, pastikan datanya bener ya.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          'Mohon maaf, sistem sedang ada kendala. Coba lagi nanti ya.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        await remoteDataSource.logout(token);
      }

      await localDataSource.clearToken();
      return const Right(null);
    } on ServerException catch (e) {
      await localDataSource.clearToken();
      return Left(
        ServerFailure(
          e.message ?? 'Belum bisa logout nih, koneksinya aman gak?',
        ),
      );
    } catch (e) {
      await localDataSource.clearToken();
      return Left(
        ServerFailure(
          'Mohon maaf, sistem sedang ada kendala. Coba lagi nanti ya.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure('Sesi bermasalah nih, coba login ulang ya.'));
    }
  }
}
