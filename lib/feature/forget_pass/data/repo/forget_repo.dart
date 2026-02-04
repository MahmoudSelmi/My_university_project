import 'package:auth_slmi/core/network/api_helper.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/api_response.dart';
import '../../../../core/network/app_endpoints.dart';

class ForgetRepo {
  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, ApiResponse>> forget({required String email}) async {
    try {
      final response = await apiHelper.postRequest(
        endPoint: ApiEndpoints.forgetPassword,
        data: {'email': email},
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
