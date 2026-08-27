import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../entities/transaction.dart';
import '../repositories/history_repository.dart';

class GetTransactions {
  final HistoryRepository repository;

  GetTransactions(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await repository.getTransactions();
  }
}
