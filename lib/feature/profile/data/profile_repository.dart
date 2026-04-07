import 'package:auth_slmi/feature/Home/data/DioHelper.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> getProfile() async {
    final response = await DioHelper.getData(
      url: 'users/profile',
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ZDI2ZGUwODYyMjlhMjhkNDcxYzNmYSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzc1NTk3NzUzLCJleHAiOjE3ODQyMzc3NTN9.pLZSDtWwBxVUAZcce53iw0AsI8CA8wK7CRldHMfFLdw",
      data: {},
    );
    return response.data;
  }
}
