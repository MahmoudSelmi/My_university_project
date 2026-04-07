class ProjectModel {
  String? projectId;
  String? projectTitle;
  String? projectDescription;
  String? projectYear;
  String? projectStatus;
  String? projectType;
  String? departmentName;
  String? universityName;

  String? doctorFullName;
  String? doctorEmail;
  String? doctorPhone;

  String? teamName;
  String? teamCode;

  List<TeamMember>? teamMembers;
  List<String>? technologies;
  List<ProjectFile>? files;

  ProjectModel.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    projectTitle = json['projectTitle'];
    projectDescription = json['projectDescription'];
    projectYear = json['projectYear'];
    projectStatus = json['projectStatus'];
    projectType = json['projectType'];
    departmentName = json['departmentName'];
    universityName = json['universityName'];

    doctorFullName = json['doctorFullName'];
    doctorEmail = json['doctorEmail'];
    doctorPhone = json['doctorPhone'];

    teamName = json['teamName'];
    teamCode = json['teamCode'];

    teamMembers =
        (json['teamMembers'] as List?)
            ?.map((e) => TeamMember.fromJson(e))
            .toList();

    technologies =
        (json['technologies'] as List?)?.map((e) => e.toString()).toList();

    files =
        (json['files'] as List?)?.map((e) => ProjectFile.fromJson(e)).toList();
  }
}

class TeamMember {
  String? memberId;
  String? memberFullName;
  String? memberRole;
  bool? memberIsLeader;

  TeamMember.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    memberFullName = json['memberFullName'];
    memberRole = json['memberRole'];
    memberIsLeader = json['memberIsLeader'];
  }
}

class ProjectFile {
  String? fileId;
  String? fileName;
  String? filePath;

  ProjectFile.fromJson(Map<String, dynamic> json) {
    fileId = json['fileId'];
    fileName = json['fileName'];
    filePath = json['filePath'];
  }
}
