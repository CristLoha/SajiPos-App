import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import '../models/cost_setting_model.dart';

abstract class CostSettingRemoteDataSource {
  Future<CostSettingModel> getCostSetting(String token);
  Future<CostSettingModel> updateCostSetting(String token, CostSettingModel taxModel);
}

class CostSettingRemoteDataSourceImpl implements CostSettingRemoteDataSource {
  final Dio dio;

  CostSettingRemoteDataSourceImpl({required this.dio});

  @override
  Future<CostSettingModel> getCostSetting(String token) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/settings/cost-calculation',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return CostSettingModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<CostSettingModel> updateCostSetting(String token, CostSettingModel taxModel) async {
    try {
      final response = await dio.put(
        '${ApiConstants.baseUrl}/settings/cost-calculation',
        data: taxModel.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return CostSettingModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? e.message);
    }
  }
}
