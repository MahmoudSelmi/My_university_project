// TODO Implement this library.
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  // دي اللي بناديها في الـ main عشان نجهز الملف
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // ميثود لحفظ أي نوع داتا (bool, String, int, double)
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  // ميثود لقراءة الداتا
  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  // ميثود لمسح داتا معينة (زي التوكن وقت اللوج أوت)
  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}
