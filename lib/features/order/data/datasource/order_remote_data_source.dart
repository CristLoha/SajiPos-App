import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/features/order/data/models/order_model.dart';
import 'package:saji_pos_app/features/order/data/models/order_request_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> submitOrder(String token, OrderRequestModel order);
  Future<OrderModel> getOrderStatus(String token, int orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl({required this.dio});
  final String productsEndpoint = ApiConstants.productsEndpoint;
  @override
  Future<OrderModel> submitOrder(String token, OrderRequestModel order) async {
    try {
      final response = await dio.post(
        ApiConstants.ordersEndpoint,
        data: order.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> orderData = Map<String, dynamic>.from(
          responseData['data'] ?? {},
        );

        if (responseData.containsKey('payment_details') &&
            !orderData.containsKey('payment_details')) {
          orderData['payment_details'] = responseData['payment_details'];
        }

        return OrderModel.fromJson(orderData);
      } else {
        throw const ServerException('Pesanan gagal diproses nih, coba cek koneksi ya.');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final message =
            e.response?.data['message'] ?? 'Pesanan gagal diproses nih, coba cek koneksi ya.';
        throw ServerException(message);
      }
      throw ServerException('Masalah koneksi internet atau server: $e');
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: $e');
    }
  }

  @override
  Future<OrderModel> getOrderStatus(String token, int orderId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.ordersEndpoint}/$orderId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw const ServerException('Cek status pesanan lagi gagal nih, coba bentar lagi ya.');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final message =
            e.response?.data['message'] ?? 'Cek status pesanan lagi gagal nih, coba bentar lagi ya.';
        throw ServerException(message);
      }
      throw ServerException('Masalah koneksi internet atau server: $e');
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: $e');
    }
  }
}
