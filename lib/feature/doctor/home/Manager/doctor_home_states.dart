import 'package:auth_slmi/core/Models/project_model.dart';

abstract class DoctorHomeStates {}

class DoctorHomeInitial extends DoctorHomeStates {}

class DoctorHomeLoading extends DoctorHomeStates {}

class DoctorHomeSuccess extends DoctorHomeStates {
  final List<ProjectModel> projects;
  final Map<String, dynamic> stats;

  DoctorHomeSuccess(
    this.projects,
    this.stats, {
    required List<dynamic> pendingRequests,
  });

  Object? get pendingRequests => null;
}

class DoctorHomeError extends DoctorHomeStates {
  final String message;
  DoctorHomeError(this.message);
}
