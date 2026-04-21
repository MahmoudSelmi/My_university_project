import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:auth_slmi/core/helper/CacheHelper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  void toggleTheme(bool isDark) {
    CacheHelper.saveData(key: 'isDark', value: isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void _loadTheme() {
    bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
