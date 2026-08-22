import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exception.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});

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
      debugPrint('=== DEBUG LOGIN ===');
      debugPrint('URL: ${ApiConstants.loginEndpoint}');
      debugPrint('Payload: {"email": "$email", "password": "$password"}');
      
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw const ServerException(
          'Email atau kata sandi Anda salah. Silakan periksa kembali.',
        );
      }
    } on DioException catch (e) {
      debugPrint('=== DEBUG DIO EXCEPTION ===');
      debugPrint('Type: ${e.type}');
      debugPrint('Error message: ${e.message}');
      debugPrint('Response status code: ${e.response?.statusCode}');
      debugPrint('Response data: ${e.response?.data}');
      debugPrint('Error detail: ${e.error}');

      String userFriendlyMessage = 'Gagal masuk ke sistem. Silakan coba beberapa saat lagi.';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        userFriendlyMessage = 'Koneksi internet lambat atau terputus. Silakan coba lagi.';
      } else if (e.type == DioExceptionType.connectionError) {
        userFriendlyMessage = 'Tidak dapat terhubung ke server kasir. Periksa koneksi internet Anda.';
      } else if (e.response != null) {
        final int? statusCode = e.response?.statusCode;
        if (statusCode == 400 || statusCode == 401) {
          userFriendlyMessage = 'Email atau kata sandi salah. Silakan coba lagi.';
        } else if (statusCode == 422) {
          userFriendlyMessage = 'Data yang Anda masukkan tidak sesuai format.';
        } else if (statusCode == 500) {
          userFriendlyMessage = 'Server kasir sedang mengalami gangguan. Hubungi admin toko Anda.';
        }
      }

      throw ServerException(userFriendlyMessage);
    } catch (e) {
      debugPrint('=== DEBUG SYSTEM EXCEPTION ===');
      debugPrint('Error: $e');
      throw const ServerException('Terjadi kesalahan tidak terduga. Silakan buka ulang aplikasi.');
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
        throw const ServerException('Gagal keluar dari aplikasi.');
      }
    } on DioException catch (e) {
      String userFriendlyMessage = 'Gagal memproses keluar sistem.';
      
      if (e.type == DioExceptionType.connectionError) {
        userFriendlyMessage = 'Gagal logout karena tidak ada jaringan internet.';
      }
      
      throw ServerException(userFriendlyMessage);
    } catch (e) {
      throw const ServerException('Gagal memproses keluar sistem.');
    }
  }
}
