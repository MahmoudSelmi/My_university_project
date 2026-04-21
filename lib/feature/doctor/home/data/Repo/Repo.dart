import 'package:auth_slmi/feature/doctor/home/data/DioHelper.dart';
import 'package:dio/dio.dart';

class DoctorRepo {
  Future<Response> getDoctorStats() async {
    return await ApiService.getData(url: "projects/doctor/stats");
  }

  Future<Response> getStartProjects() async {
    return await ApiService.getData(
      url: "projects/all/doctor",
      query: {"status": "start"},
    );
  }
}
