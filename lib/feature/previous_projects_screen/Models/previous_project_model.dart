class AllProjectsModel {
  bool? success;
  Stats? stats;
  List<ProjectItem>? data;

  AllProjectsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    if (json['data'] != null) {
      data =
          (json['data'] as List).map((v) => ProjectItem.fromJson(v)).toList();
    }
  }
}

class Stats {
  int? totalProjects, completedProjects, currentYearProjects;
  Stats.fromJson(Map<String, dynamic> json) {
    totalProjects = json['totalProjects'];
    completedProjects = json['completedProjects'];
    currentYearProjects = json['currentYearProjects'];
  }
}

class ProjectItem {
  String? projectId,
      projectTitle,
      projectDescription,
      projectYear,
      doctorFullName;
  ProjectItem.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    projectTitle = json['projectTitle'];
    projectDescription = json['projectDescription'];
    projectYear = json['projectYear'];
    doctorFullName = json['doctorFullName'];
  }
}
