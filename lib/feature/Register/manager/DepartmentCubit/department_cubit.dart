import 'package:auth_slmi/feature/Register/manager/DepartmentCubit/department_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/department_repo.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit() : super(DepartmentInitial());
  static DepartmentCubit get(context) => BlocProvider.of(context);
  getDepartments() async {
    DepartmentRepo departmentRepo = DepartmentRepo();
    emit(DepartmentLoading());
    var response = await departmentRepo.getDepartments();
    response.fold(
      (error) {
        emit(DepartmentError(error));
      },
      (data) {
        emit(DepartmentSuccess(data));
      },
    );
  }
}
