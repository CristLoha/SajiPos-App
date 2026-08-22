import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/store_profile_model.dart';

abstract class StoreProfileRemoteDataSource {
  Future<StoreProfileModel> getStoreProfile(String token);
}

class StoreProfileRemoteDataSourceImpl implements StoreProfileRemoteDataSource {
  final Dio dio;

  StoreProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<StoreProfileModel> getStoreProfile(String token) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/settings/store',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return StoreProfileModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get store profile',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? e.message ?? 'Server error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
