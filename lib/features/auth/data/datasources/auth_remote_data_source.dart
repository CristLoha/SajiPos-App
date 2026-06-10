import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
  });

  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          response.data['message']?.toString() ?? 'Gagal masuk: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message']?.toString() ?? e.message ?? 'Terjadi kesalahan koneksi';
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Masalah koneksi internet atau server: $e');
    }
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          response.data['message']?.toString() ?? 'Gagal mendaftar: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message']?.toString() ?? e.message ?? 'Terjadi kesalahan koneksi';
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Masalah koneksi internet atau server: $e');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      final response = await dio.post(
        ApiConstants.logoutEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          response.data['message']?.toString() ?? 'Gagal keluar: ${response.statusMessage}',
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
