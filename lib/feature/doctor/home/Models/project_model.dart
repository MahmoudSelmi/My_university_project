class DoctorProjectModel {
  final String id;
  final String title;
  final String desc;

  DoctorProjectModel({
    required this.id,
    required this.title,
    required this.desc,
  });

  factory DoctorProjectModel.fromJson(Map<String, dynamic> json) {
    return DoctorProjectModel(
      id: json['_id'] ?? '',
      title: json['projectTitle'] ?? 'No Title',
      desc: json['projectDescription'] ?? 'No Description Provided',
    );
  }
}
