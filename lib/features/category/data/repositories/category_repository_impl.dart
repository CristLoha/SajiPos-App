import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(ServerFailure('Sesi telah berakhir. Silakan login kembali.'));
      }
      final categoryModels = await remoteDataSource.getCategories(token);
      final categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil data kategori'));
    } catch (e) {
      return Left(ServerFailure('Kesalahan sistem: $e'));
    }
  }
}
