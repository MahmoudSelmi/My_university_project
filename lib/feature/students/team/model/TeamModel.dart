class TeamModel {
  String? teamName;
  String? teamCode;
  String? doctorFullName;
  String? doctorEmail;
  String? doctorPhone;
  List<TeamMember>? teamMembers;

  TeamModel.fromJson(Map<String, dynamic> json) {
    teamName = json['teamName'];
    teamCode = json['teamCode'];
    doctorFullName = json['doctorFullName'];
    doctorEmail = json['doctorEmail'];
    doctorPhone = json['doctorPhone'];
    if (json['teamMembers'] != null) {
      teamMembers = <TeamMember>[];
      json['teamMembers'].forEach((v) {
        teamMembers!.add(TeamMember.fromJson(v));
      });
    }
  }
}

class TeamMember {
  String? memberFullName;
  String? memberEmail;
  String? memberRole;
  bool? memberIsLeader;

  TeamMember.fromJson(Map<String, dynamic> json) {
    memberFullName = json['memberFullName'];
    memberEmail = json['memberEmail'];
    memberRole = json['memberRole'];
    memberIsLeader = json['memberIsLeader'];
  }
}
