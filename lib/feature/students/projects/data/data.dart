import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://50.19.27.194:3000/api/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
    Map<String, dynamic>? data, // تم جعلها اختيارية هنا
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token ?? '', // التوكن يرسل مباشرة كما هو
        },
      ),
    );
  }

  // ... باقي الميثودز تظل كما هي
}
