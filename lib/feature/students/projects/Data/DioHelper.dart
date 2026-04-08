import 'package:dio/dio.dart';

class DioHelper {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://18.234.236.42:3000/api/v1/",
      headers: {
        "Authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ZDI2ZGUwODYyMjlhMjhkNDcxYzNmYSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzc1NTYzODY2LCJleHAiOjE3ODQyMDM4NjZ9.dHj_MJxAvCd6D7OYqL3_ZBs2xWH0Sd1BdM3IniqIQs8",
      },
    ),
  );
}
