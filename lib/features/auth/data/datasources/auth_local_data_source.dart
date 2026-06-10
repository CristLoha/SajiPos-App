import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});
  static const String _tokenKey = 'CACHED_AUTH_TOKEN';

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() {
    return Future.value(sharedPreferences.getString(_tokenKey));
  }

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(_tokenKey);
  }
}
