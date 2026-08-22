import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../datasources/category_local_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      var cachedCategories = await localDataSource.getCachedCategories();
      
      if (cachedCategories.isEmpty) {
        final syncResult = await syncCategories();
        if (syncResult.isRight()) {
          cachedCategories = await localDataSource.getCachedCategories();
        } else {
          return Left(ServerFailure(syncResult.fold((l) => l.message, (r) => 'Error')));
        }
      }

      final categories = cachedCategories.map((model) => model.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure('Kategori produk belum bisa dimuat nih.'));
    }
  }

  @override
  Future<Either<Failure, bool>> syncCategories() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'));
      }
      final categoryModels = await remoteDataSource.getCategories(token);
      await localDataSource.cacheCategories(categoryModels);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Update kategori lagi gangguan, ditunggu ya.'));
    } catch (e) {
      return Left(ServerFailure('Gagal memuat kategori terbaru dari server.'));
    }
  }
}
