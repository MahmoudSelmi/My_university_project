class ProjectModel {
  final String? id;
  final String? title;
  final String? desc;
  final String? leaderName;
  final String? year;

  ProjectModel({this.id, this.title, this.desc, this.leaderName, this.year});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'],
      title: json['project_name'] ?? "Project Title",
      desc: json['project_description'] ?? "No Description Provided",
      leaderName: json['leader_name'] ?? "Student Name",
      year: json['year'] ?? "2026",
    );
  }
}
