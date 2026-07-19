import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/features/promo/data/models/campaign_model.dart';
import 'package:saji_pos_app/features/promo/data/models/campaign_model_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CampaignRemoteDataSource {
  Future<List<CampaignModel>> getActiveCampaigns();
}

class CampaignRemoteDataSourceImpl implements CampaignRemoteDataSource {
  CampaignRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<CampaignModel>> getActiveCampaigns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await dio.get(
        '${ApiConstants.baseUrl}/campaigns',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final campaignResponse = CampaignModelResponse.fromJson(response.data);
        return campaignResponse.campaignList;
      } else {
        throw Exception('Failed to load campaigns');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan jarigan';
      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Terjadi kesalahan jarigan');
    }
  }
}
