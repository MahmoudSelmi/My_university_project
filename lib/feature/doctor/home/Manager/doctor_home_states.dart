import '../../../../core/Models/project_model.dart';

abstract class DoctorStates {}

class DoctorHomeInitial extends DoctorStates {}

class DoctorLoading extends DoctorStates {}

class DoctorSuccess extends DoctorStates {
  final List<ProjectModel> projects;
  final Map<String, dynamic>? stats; // علامة الاستفهام دي حلت الإيرور
  DoctorSuccess(this.projects, this.stats);
}

class DoctorError extends DoctorStates {
  final String message;
  DoctorError(this.message);
}
