import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/product_model.dart';
import '../models/product_response.dart';
import '../models/product_detail_model.dart';
import '../models/product_detail_response.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(
    String token, {
    String? search,
    int? categoryId,
  });
  Future<ProductDetailModel> getProductDetail(String token, int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  final String productsEndpoint = ApiConstants.productsEndpoint;

  @override
  Future<List<ProductModel>> getProducts(
    String token, {
    String? search,
    int? categoryId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (search != null && search.isNotEmpty) {
        queryParams['name'] = search;
      }

      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }
      final response = await dio.get(
        productsEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(
          response.data as Map<String, dynamic>,
        ).productList;
      } else {
        debugPrint('🔥 [API ERROR] Gagal ambil produk: ${response.statusCode} - ${response.statusMessage}');
        throw ServerException(
          'Wah gagal narik data nih: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      debugPrint('🔥 [DIO EXCEPTION] getProducts: ${e.response?.statusCode} - ${e.message}');
      debugPrint('🔥 [DIO RESPONSE DATA]: ${e.response?.data}');
      throw ServerException(e.message ?? 'Terjadi kesalahan koneksi');
    } catch (e) {
      debugPrint('🔥 [UNKNOWN ERROR] getProducts: $e');
      throw ServerException('Masalah koneksi internet atau server: $e');
    }
  }

  @override
  Future<ProductDetailModel> getProductDetail(String token, int id) async {
    try {
      final response = await dio.get(
        '$productsEndpoint/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProductDetailResponse.fromJson(
          response.data as Map<String, dynamic>,
        ).data;
      } else {
        throw ServerException(
          response.statusMessage ?? 'Detail produknya belum mau muncul nih.',
        );
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message']?.toString() ??
          e.message ??
          'Terjadi kesalahan koneksi';
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Masalah koneksi internet atau server: $e');
    }
  }
}
