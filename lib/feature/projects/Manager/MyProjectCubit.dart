import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/Home/data/DioHelper.dart';
import 'package:auth_slmi/feature/projects/Manager/MyProjectState.dart';
import 'package:dio/dio.dart';
// تأكد من مسار الـ CacheHelper الحقيقي عندك

class MyProjectCubit extends Cubit<MyProjectState> {
  MyProjectCubit() : super(MyProjectInitial());

  static MyProjectCubit get(context) =>
      BlocProvider.of<MyProjectCubit>(context);

  ProjectModel? myProject;

  // بنجيب التوكن من الـ CacheHelper اللي متسجل فيه وقت اللوجين
  String? get currentToken => CacheHelper.getData(key: 'token');
  void getMyProject() async {
    emit(MyProjectLoading());

    if (currentToken == null) {
      emit(MyProjectError("يرجى تسجيل الدخول أولاً"));
      return;
    }

    try {
      final response = await DioHelper.getData(
        url: 'projects/my-project',
        token: currentToken,
        data: {},
      );

      if (response.statusCode == 200) {
        myProject = ProjectModel.fromJson(response.data['data']);
        emit(MyProjectSuccess(myProject!));
      }
    } on DioException catch (error) {
      String message =
          error.response?.data['message'] ?? "مشكلة في الاتصال بالسيرفر";
      emit(MyProjectError(message));
    }
  }

  void deleteProjectImage() async {
    emit(MyProjectActionLoading());
    try {
      final response = await DioHelper.deleteData(
        url: 'projects/delete-image',
        token: currentToken,
      );
      if (response.statusCode == 200) {
        emit(MyProjectActionSuccess());
        getMyProject();
      }
    } on DioException catch (error) {
      emit(
        MyProjectActionError(error.response?.data['message'] ?? "فشل الحذف"),
      );
    }
  }
}
