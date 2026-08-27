import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions() async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions();
      return Right(
        remoteTransactions.map((model) => model.toEntity()).toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Terjadi kesalahan pada server'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncMidtransStatus(int orderId) async {
    try {
      await remoteDataSource.syncMidtransStatus(orderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Terjadi kesalahan pada server'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
