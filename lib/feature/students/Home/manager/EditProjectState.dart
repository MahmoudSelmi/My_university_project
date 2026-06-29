import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';
import 'package:bloc/bloc.dart';
import 'package:auth_slmi/core/Models/project_model.dart';

// States
abstract class EditProjectState {}

class EditProjectInitial extends EditProjectState {}

class EditProjectLoading extends EditProjectState {}

class EditProjectSuccess extends EditProjectState {
  final ProjectModel updatedProject;
  EditProjectSuccess(this.updatedProject);
}

class EditProjectError extends EditProjectState {
  final String message;
  EditProjectError(this.message);
}

// Cubit
class EditProjectCubit extends Cubit<EditProjectState> {
  EditProjectCubit() : super(EditProjectInitial());

  void updateProject({
    required String projectId,
    required String title,
    required String description,
    required String year,
    required String type,
    required String status,
  }) async {
    emit(EditProjectLoading());

    try {
      // نبعت الداتا الجديدة للـ API عن طريق PATCH أو PUT حسب الـ API بتاعك
      final response = await DioHelper.patchData(
        url: 'projects/update/$projectId', // عدل الـ URL حسب الـ API
        data: {
          'projectTitle': title,
          'projectDescription': description,
          'projectYear': year,
          'projectType': type,
          'projectStatus': status,
        },
      );

      if (response.data['success'] == true) {
        // نحدث الموديل بالداتا الجديدة اللي رجعت من السيرفر
        final updatedProject = ProjectModel.fromJson(response.data['data']);
        emit(EditProjectSuccess(updatedProject));
      } else {
        emit(EditProjectError(response.data['message'] ?? "Update Failed"));
      }
    } catch (error) {
      emit(EditProjectError("Error connecting to server: ${error.toString()}"));
    }
  }
}
