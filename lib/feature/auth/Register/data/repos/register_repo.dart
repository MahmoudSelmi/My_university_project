import 'package:auth_slmi/core/network/api_helper.dart';
import 'package:auth_slmi/core/network/api_response.dart';
import 'package:auth_slmi/core/network/app_endpoints.dart';
import 'package:dartz/dartz.dart';

class RegisterRepo {
  ApiHelper apiHelper = ApiHelper();
  Future<Either<String, ApiResponse>> register({
    required String universityCode,
    required String name,
    required String email,
    required String password,
    String? universityId,
    String? departmentId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'fullName': name,
        'email': email,
        'password': password,
        'universityCode': universityCode,
        'universityId': universityId,
        'departmentId': departmentId,
      };

      var response = await apiHelper.postRequest(
        endPoint: ApiEndpoints.register,
        data: data,
        isFormData: false,
        isProtected: false,
      );
      if (response.statusCode == 201) {
        return right(response);
      } else {
        return left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}
