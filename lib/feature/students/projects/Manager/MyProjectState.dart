import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MyProjectState {}

class MyProjectInitial extends MyProjectState {}

class MyProjectLoading extends MyProjectState {}

class MyProjectSuccess extends MyProjectState {
  final ProjectModel project;
  MyProjectSuccess(this.project);
}

class MyProjectError extends MyProjectState {
  final String message;
  MyProjectError(this.message);
}

class MyProjectActionLoading extends MyProjectState {}

class MyProjectActionSuccess extends MyProjectState {}

class MyProjectActionError extends MyProjectState {
  final String message;
  MyProjectActionError(this.message);
}

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // الـ Method اللي الـ Cubit محتاجها
  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }
}
