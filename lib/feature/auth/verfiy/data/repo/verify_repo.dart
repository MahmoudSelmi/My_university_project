import 'package:auth_slmi/core/network/api_helper.dart';
import 'package:auth_slmi/core/network/api_response.dart';
import 'package:auth_slmi/core/network/app_endpoints.dart';
import 'package:dartz/dartz.dart';

class VerifyRepo {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Either<String, ApiResponse>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiHelper.postRequest(
        endPoint: ApiEndpoints.verifyEmail,
        data: {"email": email, "code": code},
        isFormData: false,
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}
