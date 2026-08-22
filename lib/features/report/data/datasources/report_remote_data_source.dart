import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/report_summary_model.dart';
import '../models/report_summary_response.dart';

abstract class ReportRemoteDataSource {
  Future<ReportSummaryModel> getTodaySummary(String token);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReportSummaryModel> getTodaySummary(String token) async {
    try {
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await dio.get(
        ApiConstants.ordersEndpoint, 
        queryParameters: {
          'start_date': today,
          'end_date': today,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final reportResponse = ReportSummaryResponse.fromJson(response.data as Map<String, dynamic>);
        return ReportSummaryModel.fromOrders(reportResponse.orderList);
      } else {
        throw ServerException(response.statusMessage ?? 'Gagal mengambil data laporan hari ini');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Terjadi kesalahan jaringan');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
