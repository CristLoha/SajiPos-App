import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  final SharedPreferences sharedPreferences;

  ThemeCubit({required this.sharedPreferences}) : super(false) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = sharedPreferences.getBool('is_dark_mode') ?? false;
    emit(isDark);
  }

  void toggleTheme(bool isDark) {
    sharedPreferences.setBool('is_dark_mode', isDark);
    emit(isDark);
  }
}
