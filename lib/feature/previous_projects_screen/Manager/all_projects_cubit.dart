import 'package:auth_slmi/feature/Home/data/DioHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/previous_project_model.dart';

abstract class AllProjectsState {}

class AllProjectsInitial extends AllProjectsState {}

class AllProjectsLoading extends AllProjectsState {}

class AllProjectsSuccess extends AllProjectsState {
  final List<ProjectItem> projects;
  final Stats stats;
  AllProjectsSuccess(this.projects, this.stats);
}

class AllProjectsError extends AllProjectsState {
  final String message;
  AllProjectsError(this.message);
}

class AllProjectsCubit extends Cubit<AllProjectsState> {
  AllProjectsCubit() : super(AllProjectsInitial());

  static AllProjectsCubit get(context) => BlocProvider.of(context);

  void getAllProjects() async {
    emit(AllProjectsLoading());
    try {
      final response = await DioHelper.getData(url: 'projects/all', data: {});
      var model = AllProjectsModel.fromJson(response.data);
      emit(AllProjectsSuccess(model.data ?? [], model.stats!));
    } catch (e) {
      emit(AllProjectsError("فشل تحميل المشاريع"));
    }
  }
}
