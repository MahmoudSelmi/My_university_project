import 'package:dio/dio.dart';
import 'package:auth_slmi/core/helper/CacheHelper.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://54.145.14.72:3000/api/v1/",
      headers: {"Content-Type": "application/json"},
    ),
  );

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    String? token = CacheHelper.getData(key: 'token');

    dio.options.headers["Authorization"] = "Bearer $token";

    return await dio.get(url, queryParameters: query);
  }
}
