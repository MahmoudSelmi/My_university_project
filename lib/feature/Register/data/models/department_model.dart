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
        data!.add(new Data.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
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

  Data(
      {this.sId,
        this.departmentName,
        this.universityId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    departmentName = json['departmentName'];
    universityId = json['universityId'] != null
        ? new UniversityId.fromJson(json['universityId'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['departmentName'] = this.departmentName;
    if (this.universityId != null) {
      data['universityId'] = this.universityId!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['universityName'] = this.universityName;
    return data;
  }
}
