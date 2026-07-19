import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/features/promo/data/models/discount_model.dart';
import 'package:saji_pos_app/features/promo/data/models/discount_model_response.dart';

abstract class DiscountRemoteDataSource {
  Future<List<DiscountModel>> getActiveDiscounts(String token);
}

class DiscountRemoteDataSourceImpl implements DiscountRemoteDataSource {
  final Dio dio;

  DiscountRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DiscountModel>> getActiveDiscounts(String token) async {
    try {
      final response = await dio.get(
        ApiConstants.discountsEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DiscountModelResponse.fromJson(
          response.data as Map<String, dynamic>,
        ).discountList;
      } else {
        throw ServerException(
          response.statusMessage ?? 'Gagal memuat data diskon',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Terjadi kesalahan jaringan');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
