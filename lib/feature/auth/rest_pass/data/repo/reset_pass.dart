import 'package:auth_slmi/core/network/api_helper.dart';
import 'package:auth_slmi/core/network/api_response.dart';
import 'package:auth_slmi/core/network/app_endpoints.dart';
import 'package:dartz/dartz.dart';

class ResetRepo {
  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, ApiResponse>> reset({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiHelper.postRequest(
        endPoint: ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'code': code,
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        },
        isFormData: false,
        isProtected: false,
      );
      if (response.statusCode == 200) {
        return right(response);
      } else {
        return left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}
