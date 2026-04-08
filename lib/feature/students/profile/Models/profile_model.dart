class ProfileModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? bio;
  final String? universityName;
  final String? departmentName;

  ProfileModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.bio,
    this.universityName,
    this.departmentName,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ProfileModel(
      id: data['_id'],
      fullName: "MahmoudSelmi",
      email: "mahmoud.m.selmy1@gmail.com",
      phoneNumber: data['phoneNumber'],
      bio: data['bio'],
      universityName: "bis",
      departmentName: data['departmentId']?['departmentName'],
    );
  }
}
