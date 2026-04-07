import 'package:auth_slmi/feature/previous_projects_screen/Models/previous_project_model.dart';

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
