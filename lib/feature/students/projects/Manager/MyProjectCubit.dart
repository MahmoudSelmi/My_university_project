import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/project_model.dart';

abstract class MyProjectState {}

class MyProjectInitial extends MyProjectState {}

class MyProjectLoading extends MyProjectState {}

class MyProjectSuccess extends MyProjectState {
  final MyProjectModel model;
  MyProjectSuccess(this.model);
}

class MyProjectError extends MyProjectState {
  final String err;
  MyProjectError(this.err);
}

class MyProjectCubit extends Cubit<MyProjectState> {
  MyProjectCubit() : super(MyProjectInitial());

  static MyProjectCubit get(context) => BlocProvider.of(context);

  void getMyProjectDetails() async {
    emit(MyProjectLoading());
    try {
      final response = await DioHelper.getData(
        url: 'projects/my-project',
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ZDI2ZGUwODYyMjlhMjhkNDcxYzNmYSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzc1NzM2NTg2LCJleHAiOjE3ODQzNzY1ODZ9.rpxUN6GKUkg2hxXcnFvs5uFk0dH8T-o5FHkO-zXAkEU',
        data: {},
      );

      if (response.data['success'] == true) {
        emit(MyProjectSuccess(MyProjectModel.fromJson(response.data['data'])));
      } else {
        emit(MyProjectError(response.data['message'] ?? "تعذر جلب البيانات"));
      }
    } catch (e) {
      emit(MyProjectError("حدث خطأ في الشبكة: ${e.toString()}"));
    }
  }

  void uploadNewProject({required String title, required File file}) {}

  void downloadProjectFile({required String url, required String fileName}) {}
}

Future<void> downloadProjectFile({
  required String url,
  required String fileName,
}) async {
  try {
    // 1. تحديد مكان الحفظ (مجلد التحميلات أو المستندات)
    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/$fileName";

    // 2. استخدام Dio للتحميل
    await Dio().download(
      url,
      filePath,
      onReceiveProgress: (count, total) {
        print(
          "Download Progress: ${(count / total * 100).toStringAsFixed(0)}%",
        );
      },
    );

    print("File saved at: $filePath");
  } catch (e) {
    print("Download Error: $e");
  }
}
