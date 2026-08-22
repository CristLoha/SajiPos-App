import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/report_repository.dart';
import '../entities/report_summary.dart';

class GetTodaySummary {
  final ReportRepository repository;

  GetTodaySummary(this.repository);

  Future<Either<Failure, ReportSummary>> call() async {
    return await repository.getTodaySummary();
  }
}
