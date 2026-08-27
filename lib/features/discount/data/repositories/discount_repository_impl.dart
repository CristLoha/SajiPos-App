import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import 'package:saji_pos_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/repositories/discount_repository.dart';
import 'package:saji_pos_app/features/discount/data/datasources/discount_remote_data_source.dart';
import 'package:saji_pos_app/features/discount/data/datasources/discount_local_data_source.dart';

class DiscountRepositoryImpl implements DiscountRepository {
  final DiscountRemoteDataSource remoteDataSource;
  final DiscountLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  DiscountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Discount>>> getActiveDiscounts({
    String? status,
    String? search,
  }) async {
    try {
      var cachedDiscounts = await localDataSource.getCachedDiscounts();

      if (cachedDiscounts.isEmpty) {
        final syncResult = await syncDiscounts();
        if (syncResult.isRight()) {
          cachedDiscounts = await localDataSource.getCachedDiscounts();
        } else {
          return Left(
            ServerFailure(syncResult.fold((l) => l.message, (r) => 'Error')),
          );
        }
      }

      var filtered = cachedDiscounts;
      if (status != null && status.isNotEmpty) {
        filtered = filtered.where((d) => d.status == status).toList();
      }
      if (search != null && search.isNotEmpty) {
        filtered = filtered
            .where(
              (d) =>
                  d.name.toLowerCase().contains(search.toLowerCase()) ||
                  d.code.toLowerCase().contains(search.toLowerCase()),
            )
            .toList();
      }

      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure('Data diskon belum bisa dimuat.'));
    }
  }

  @override
  Future<Either<Failure, Discount>> checkDiscountCode(String code) async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'),
        );
      }

      final remoteModel = await remoteDataSource.checkDiscountCode(token, code);
      return Right(remoteModel.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Kode diskonnya gagal dicek, jangan-jangan typo?',
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
  Future<Either<Failure, bool>> syncDiscounts() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'),
        );
      }
      final remoteModels = await remoteDataSource.getDiscounts(token);
      final discounts = remoteModels.map((m) => m.toEntity()).toList();
      await localDataSource.cacheDiscounts(discounts);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Data diskon terbaru belum bisa ditarik nih.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Gagal memuat diskon terbaru dari server.'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnseenDiscountCount() async {
    try {
      final activeDiscountsResult = await getActiveDiscounts(status: 'active');
      return await activeDiscountsResult.fold((failure) async => Left(failure), (
        discounts,
      ) async {
        final seenIds = await localDataSource.getSeenDiscounts();
        final unseenCount = discounts
            .where((d) => !seenIds.contains(d.id))
            .length;
        return Right(unseenCount);
      });
    } catch (e) {
      return Left(
        ServerFailure(
          'Mohon maaf, sistem sedang ada kendala. Coba lagi nanti ya.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markDiscountsAsSeen() async {
    try {
      final activeDiscountsResult = await getActiveDiscounts(status: 'active');
      return await activeDiscountsResult.fold((failure) async => Left(failure), (
        discounts,
      ) async {
        final ids = discounts.map((d) => d.id).toList();
        await localDataSource.saveSeenDiscounts(ids);
        return const Right(null);
      });
    } catch (e) {
      return Left(
        ServerFailure(
          'Mohon maaf, sistem sedang ada kendala. Coba lagi nanti ya.',
        ),
      );
    }
  }
}
