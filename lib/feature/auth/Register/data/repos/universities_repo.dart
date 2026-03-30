import 'package:auth_slmi/core/network/api_helper.dart';
import 'package:auth_slmi/core/network/api_response.dart';
import 'package:auth_slmi/core/network/app_endpoints.dart';
import 'package:dartz/dartz.dart';

import '../models/universities_model.dart';

class UniversitieRepo {
  ApiHelper apiHelper = ApiHelper();
  Future<Either<String, UniversitiesModel>> getUniversities() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: ApiEndpoints.getUniversities,
        isProtected: false,
        sendRefreshToken: false,
      );
      if (response.statusCode == 200) {
        UniversitiesModel universitiesModel = UniversitiesModel.fromJson(
          response.data,
        );
        return Right(universitiesModel);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}
