import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/category_model.dart';
import '../models/category_response.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(String token);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories(String token) async {
    try {
      final response = await dio.get(
        ApiConstants.categoriesEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(
          response.data as Map<String, dynamic>,
        ).categoryList;
      } else {
        throw ServerException(
          'Data kategori belum bisa ditarik: ${response.statusMessage}',
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
