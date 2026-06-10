import 'package:dio/dio.dart';
import 'package:saji_pos_app/features/category/data/models/category_model.dart';
import 'package:saji_pos_app/features/category/data/models/category_response.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/product_model.dart';
import '../models/product_response.dart';
import '../models/product_detail_model.dart';
import '../models/product_detail_response.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String token, {String? search});
  Future<List<CategoryModel>> getProduct(String token);
  Future<ProductDetailModel> getProductDetail(String token, int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  final String productsEndpoint = ApiConstants.productsEndpoint;

  @override
  Future<List<ProductModel>> getProducts(String token, {String? search}) async {
    try {
      final response = await dio.get(
        productsEndpoint,
        queryParameters: search != null ? {'search': search} : null,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(response.data as Map<String, dynamic>).productList;
      } else {
        throw ServerException(
          'Gagal mengambil data: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Terjadi kesalahan koneksi');
    } catch (e) {
      throw ServerException('Masalah koneksi internet atau server: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getProduct(String token) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/categories',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(response.data as Map<String, dynamic>).categoryList;
      } else {
        throw ServerException(
          response.statusMessage ?? 'Gagal mengambil data kategori',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Terjadi kesalahan koneksi');
    } catch (e) {
      throw ServerException(e.toString());
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
        return ProductDetailResponse.fromJson(response.data as Map<String, dynamic>).data;
      } else {
        throw ServerException(
          response.statusMessage ?? 'Gagal mengambil detail produk',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message']?.toString() ?? e.message ?? 'Terjadi kesalahan koneksi';
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Masalah koneksi internet atau server: $e');
    }
  }
}
