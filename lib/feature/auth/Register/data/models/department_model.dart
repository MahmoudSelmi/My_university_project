class DepartmentsModel {
  bool? success;
  String? message;
  List<Data>? data;
  String? timestamp;

  DepartmentsModel({this.success, this.message, this.data, this.timestamp});

  DepartmentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class Data {
  String? sId;
  String? departmentName;
  UniversityId? universityId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.sId,
    this.departmentName,
    this.universityId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    departmentName = json['departmentName'];
    universityId =
        json['universityId'] != null
            ? UniversityId.fromJson(json['universityId'])
            : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['departmentName'] = departmentName;
    if (universityId != null) {
      data['universityId'] = universityId!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class UniversityId {
  String? sId;
  String? universityName;

  UniversityId({this.sId, this.universityName});

  UniversityId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    universityName = json['universityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['universityName'] = universityName;
    return data;
  }
}
