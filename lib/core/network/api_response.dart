import 'package:dio/dio.dart';

class ApiResponse {
  final bool success;
  final int statusCode;
  final dynamic data;
  final String message;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    required this.message,
  });

  factory ApiResponse.fromResponse(Response response) {
    final body = response.data;

    bool success = false;
    String message = '';

    if (body is Map<String, dynamic>) {
      success = body['success'] == true;

      final msg = body['message'];

      if (msg is List) {
        message = msg.join('\n');
      } else if (msg != null) {
        message = msg.toString();
      }
    } else {
      success =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    }

    return ApiResponse(
      success: success,
      statusCode: response.statusCode ?? 500,
      data: body,
      message: message,
    );
  }

  factory ApiResponse.fromError(dynamic error) {
    if (error is DioException) {
      final res = error.response;
      final data = res?.data;

      String message = "Unknown error occurred.";

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        if (msg is List) {
          message = msg.join('\n');
        } else if (msg != null) {
          message = msg.toString();
        }
      } else {
        message = _handleDioError(error);
      }

      return ApiResponse(
        success: false,
        statusCode: res?.statusCode ?? 500,
        data: data,
        message: message,
      );
    }

    return ApiResponse(
      success: false,
      statusCode: 500,
      message: 'An error occurred.',
    );
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout, please try again.";
      case DioExceptionType.sendTimeout:
        return "Send timeout, please check your internet.";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout, please try again later.";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection.";
      default:
        return "Server error occurred.";
    }
  }
}
