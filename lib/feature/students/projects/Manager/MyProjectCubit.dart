import 'package:auth_slmi/feature/students/projects/Models/project_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';

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
        token: 'YOUR_JWT_TOKEN_HERE',
        data: {}, // يفضل تخزنه في CacheHelper
      );
      if (response.data['success']) {
        emit(MyProjectSuccess(MyProjectModel.fromJson(response.data['data'])));
      } else {
        emit(MyProjectError("Failed to fetch data"));
      }
    } catch (e) {
      emit(MyProjectError(e.toString()));
    }
  }
}
