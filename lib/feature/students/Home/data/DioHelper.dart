import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://3.80.215.197:3000/api/v1/',
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
    required Map<String, String> data,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token ?? '',
        },
      ),
    );
  }

  static Future<Response> patchData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.patch(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': token ?? '',
          if (data is! FormData) 'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.delete(
      url,
      queryParameters: query,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token ?? '',
        },
      ),
    );
  }

  static Future<Response> postFileData({
    required String url,
    required FormData data,
    String? token,
  }) async {
    return await dio.post(
      url,
      data: data,
      options: Options(
        headers: {'Accept': 'application/json', 'Authorization': token ?? ''},
      ),
    );
  }

  static Future<Object?> postData({
    required String url,
    required FormData data,
    required String token,
  }) async {
    return null;
  }
}
