class ProjectModel {
  final String? projectId;
  final String? projectTitle;
  final String? projectDescription;
  final String? projectYear;
  final String? projectStatus;
  final String? projectType;
  final String? doctorFullName;
  final String? doctorImage;
  final List<String>? technologies;

  ProjectModel({
    this.projectId,
    this.projectTitle,
    this.projectDescription,
    this.projectYear,
    this.projectStatus,
    this.projectType,
    this.doctorFullName,
    this.doctorImage,
    this.technologies,
    String? universityName,
    String? teamName,
    required String id,
    required String title,
    required String description,
    required String desc,
    required String teamLeader,
    required String status,
    required String leaderName,
    required String year,
    required List<String> members,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'],
      projectTitle: json['projectTitle'],
      projectDescription: json['projectDescription'],
      projectYear: json['projectYear'],
      projectStatus: json['projectStatus'],
      projectType: json['projectType'],
      doctorFullName: json['doctorFullName'],
      doctorImage: json['doctorImage'],
      technologies:
          json['technologies'] != null
              ? List<String>.from(json['technologies'])
              : [],
      id: '',
      title: '',
      description: '',
      desc: '',
      teamLeader: '',
      status: '',
      leaderName: '',
      year: '',
      members: [],
    );
  }

  String get description => projectDescription ?? '';

  String get title => projectTitle ?? '';

  get teamLeader => null;

  get desc => null;

  String? get leaderName => null;

  String? get year => null;

  get members => null;
}
