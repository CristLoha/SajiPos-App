import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/entities/report_summary.dart';
import '../datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ReportSummary>> getTodaySummary() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(
          ServerFailure('Sesi kamu udah habis nih, login lagi yuk.'),
        );
      }

      final model = await remoteDataSource.getTodaySummary(token);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message ??
              'Laporan belum bisa dimuat, coba tarik layar buat refresh.',
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
}
