import 'package:auth_slmi/core/network/api_helper.dart';
import 'package:auth_slmi/core/network/api_response.dart';
import 'package:auth_slmi/core/network/app_endpoints.dart';
import 'package:auth_slmi/feature/auth/Register/data/models/department_model.dart';
import 'package:dartz/dartz.dart';

class DepartmentRepo {
  ApiHelper apiHelper = ApiHelper();
  Future<Either<String, DepartmentsModel>> getDepartments() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: ApiEndpoints.getDepartments,
      );
      if (response.statusCode == 200) {
        DepartmentsModel departmentsModel = DepartmentsModel.fromJson(
          response.data,
        );
        return Right(departmentsModel);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}
