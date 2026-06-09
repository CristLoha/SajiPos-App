import 'package:dio/dio.dart';
import 'package:saji_pos_app/features/category/data/models/category_model.dart';
import 'package:saji_pos_app/features/category/data/models/category_response.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/product_model.dart';
import '../models/product_response.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String token);
  Future<List<CategoryModel>> getProduct(String token);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  final String productsEndpoint = ApiConstants.productsEndpoint;

  @override
  Future<List<ProductModel>> getProducts(String token) async {
    try {
      final response = await dio.get(
        productsEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(response.data).productList;
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
        return CategoryResponse.fromJson(response.data).categoryList;
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
}
