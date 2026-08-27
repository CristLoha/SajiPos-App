import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import '../models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> syncMidtransStatus(int orderId);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  HistoryRemoteDataSourceImpl({required this.dio, required this.sharedPreferences});

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');
      
      final response = await dio.get(
        ApiConstants.ordersEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List dataList = [];
        if (response.data['data'] is List) {
          dataList = response.data['data'] as List;
        } else if (response.data['data'] is Map && response.data['data']['data'] is List) {
          dataList = response.data['data']['data'] as List;
        } else if (response.data is List) {
          dataList = response.data as List;
        }
        
        return dataList.map((json) => TransactionModel.fromJson(json)).toList();
      } else {
        throw ServerException('Gagal mengambil data riwayat pesanan');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null && e.response?.data is Map) {
        final message = e.response?.data['message'] ?? 'Gagal mengambil data riwayat pesanan';
        throw ServerException(message);
      }
      throw ServerException('Masalah koneksi internet atau server');
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }

  @override
  Future<void> syncMidtransStatus(int orderId) async {
    try {
      final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');
      final response = await dio.get(
        '${ApiConstants.ordersEndpoint}/$orderId/check-status',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ServerException('Gagal menyinkronkan status pesanan');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null && e.response?.data is Map) {
        final message = e.response?.data['message'] ?? 'Gagal menyinkronkan status pesanan';
        throw ServerException(message);
      }
      throw ServerException('Masalah koneksi internet atau server');
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }
}
