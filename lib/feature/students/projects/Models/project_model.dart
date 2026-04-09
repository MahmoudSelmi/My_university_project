class MyProjectModel {
  final String? projectId,
      projectTitle,
      projectDescription,
      projectYear,
      projectStatus,
      projectLink,
      projectType,
      projectMainObjectives;
  final String? doctorFullName, doctorEmail, doctorPhone, teamName, teamCode;
  final List<TeamMember>? teamMembers;
  final List<String>? technologies;
  final List<ProjectFile>? files;

  MyProjectModel({
    this.projectId,
    this.projectTitle,
    this.projectDescription,
    this.projectYear,
    this.projectStatus,
    this.projectLink,
    this.projectType,
    this.projectMainObjectives,
    this.doctorFullName,
    this.doctorEmail,
    this.doctorPhone,
    this.teamName,
    this.teamCode,
    this.teamMembers,
    this.technologies,
    this.files,
  });

  factory MyProjectModel.fromJson(Map<String, dynamic> json) {
    return MyProjectModel(
      projectId: json['projectId'],
      projectTitle: json['projectTitle'],
      projectDescription: json['projectDescription'],
      projectYear: json['projectYear'],
      projectStatus: json['projectStatus'],
      projectLink: json['projectLink'],
      projectType: json['projectType'],
      projectMainObjectives: json['projectMainObjectives'],
      doctorFullName: json['doctorFullName'],
      doctorEmail: json['doctorEmail'],
      doctorPhone: json['doctorPhone'],
      teamName: json['teamName'],
      teamCode: json['teamCode'],
      technologies:
          json['technologies'] != null
              ? List<String>.from(json['technologies'])
              : [],
      teamMembers:
          (json['teamMembers'] as List?)
              ?.map((e) => TeamMember.fromJson(e))
              .toList() ??
          [],
      files:
          (json['files'] as List?)
              ?.map((e) => ProjectFile.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TeamMember {
  final String? fullName, role;
  final bool? isLeader;
  TeamMember({this.fullName, this.role, this.isLeader});
  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    fullName: json['memberFullName'],
    role: json['memberRole'],
    isLeader: json['memberIsLeader'],
  );
}

class ProjectFile {
  final String? fileName, filePath;
  ProjectFile({this.fileName, this.filePath});
  factory ProjectFile.fromJson(Map<String, dynamic> json) =>
      ProjectFile(fileName: json['fileName'], filePath: json['filePath']);
}
