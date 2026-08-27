import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../entities/transaction.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions();
  Future<Either<Failure, void>> syncMidtransStatus(int orderId);
}
