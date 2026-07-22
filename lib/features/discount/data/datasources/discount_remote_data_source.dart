import 'package:dio/dio.dart';
import 'package:saji_pos_app/core/constants/api_constants.dart';
import 'package:saji_pos_app/core/error/exception.dart';
import 'package:saji_pos_app/features/discount/data/models/discount_model.dart';
import 'package:saji_pos_app/features/discount/data/models/discount_response.dart';

abstract class DiscountRemoteDataSource {
  Future<List<DiscountModel>> getDiscounts(
    String token, {
    String? status,
    String? search,
  });

  Future<DiscountModel> checkDiscountCode(String token, String code);
}

class DiscountRemoteDataSourceImpl implements DiscountRemoteDataSource {
  final Dio dio;

  DiscountRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DiscountModel>> getDiscounts(
    String token, {
    String? status,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await dio.get(
        ApiConstants.discountsEndpoint,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DiscountResponse.fromJson(
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

  @override
  Future<DiscountModel> checkDiscountCode(String token, String code) async {
    try {
      final response = await dio.post(
        '${ApiConstants.discountsEndpoint}/check',
        data: {'code': code},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DiscountModel.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          response.statusMessage ?? 'Kode promo tidak valid',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Kode promo tidak valid atau sudah kedaluwarsa');
      }
      throw ServerException(e.message ?? 'Terjadi kesalahan jaringan');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
