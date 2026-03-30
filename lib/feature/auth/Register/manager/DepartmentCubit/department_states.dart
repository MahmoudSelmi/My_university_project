import 'package:auth_slmi/feature/auth/Register/data/models/department_model.dart';

abstract class DepartmentState {}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentSuccess extends DepartmentState {
  final DepartmentsModel departments;

  DepartmentSuccess(this.departments);
}

class DepartmentError extends DepartmentState {
  final String message;

  DepartmentError(this.message);
}
