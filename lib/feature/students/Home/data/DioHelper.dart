import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhM2E1MTUxNjUxNjZjY2JiOTRlZDM4NSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzgyMjA4ODIzLCJleHAiOjE3OTA4NDg4MjN9.-8ujuncfWgTwsAXugLBvarqXjoRLHAb5B6-1x8YxyXY';

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://3.89.207.112:3000/api/v1/",
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token,
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    required Map<dynamic, dynamic> data,
    required String token,
  }) async {
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> patchData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return await dio.patch(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.delete(url, queryParameters: query);
  }

  static Future<Response> postFileData({
    required String url,
    required FormData data,
  }) async {
    return await dio.post(url, data: data);
  }

  static Future<Response> postData({
    required String url,
    required FormData data,
  }) async {
    return await dio.post(url, data: data);
  }
}
