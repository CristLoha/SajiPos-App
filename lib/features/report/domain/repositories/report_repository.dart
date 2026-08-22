import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/report_summary.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportSummary>> getTodaySummary();
}
