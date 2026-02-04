import 'package:auth_slmi/core/network/app_endpoints.dart';
import 'package:auth_slmi/feature/Login/data/model/login_model.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_response.dart';

class LoginRepo {
  final ApiHelper apiHelper = ApiHelper();

  Future<Either<String, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiHelper.postRequest(
        endPoint: ApiEndpoints.login,
        data: {'email': email, 'password': password},
        isFormData: false,
        isProtected: false,
      );

      if (response.statusCode != 200) {
        return Left(response.message);
      }

      final loginModel = LoginModel.fromJson(response.data);

      final accessToken = loginModel.data?.accessToken;
      final refreshToken = loginModel.data?.refreshToken;

      if (accessToken == null || refreshToken == null) {
        return const Left("Invalid login response");
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);

      return Right(loginModel);
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}
