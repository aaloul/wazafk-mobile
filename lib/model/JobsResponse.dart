// To parse this JSON data, do
//
//     final jobsResponse = jobsResponseFromJson(jsonString);

import 'dart:convert';

import 'SkillsResponse.dart';

JobsResponse jobsResponseFromJson(String str) =>
    JobsResponse.fromJson(json.decode(str));

String jobsResponseToJson(JobsResponse data) => json.encode(data.toJson());

class JobsResponse {
  bool? success;
  String? message;
  Data? data;

  JobsResponse({this.success, this.message, this.data});

  factory JobsResponse.fromJson(Map<String, dynamic> json) => JobsResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Meta? meta;
  List<Job>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Job>.from(json["list"]!.map((x) => Job.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Job {
  String? hashcode;
  String? memberHashcode;
  String? memberFirstName;
  String? memberLastName;
  String? categoryHashcode;
  String? categoryName;
  String? title;
  String? image;
  String? description;
  String? unitPrice;
  String? totalPrice;
  int? featured;
  int? rating;
  String? overview;
  String? responsibilities;
  String? requirememts;
  String? workLocationType;
  dynamic address;
  DateTime? startDatetime;
  DateTime? expiryDatetime;
  String? periodicity;
  String? tasksMilestones;
  int? nbApplicants;
  int? archived;
  int? status;
  DateTime? createdAt;
  List<Skill>? skills;

  Job({
    this.hashcode,
    this.memberHashcode,
    this.memberFirstName,
    this.memberLastName,
    this.categoryHashcode,
    this.categoryName,
    this.title,
    this.image,
    this.description,
    this.unitPrice,
    this.totalPrice,
    this.featured,
    this.rating,
    this.overview,
    this.responsibilities,
    this.requirememts,
    this.workLocationType,
    this.address,
    this.startDatetime,
    this.expiryDatetime,
    this.periodicity,
    this.tasksMilestones,
    this.nbApplicants,
    this.archived,
    this.status,
    this.createdAt,
    this.skills,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    hashcode: json["hashcode"],
    memberHashcode: json["member_hashcode"],
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    categoryHashcode: json["category_hashcode"],
    categoryName: json["category_name"],
    title: json["title"],
    image: json["image"],
    description: json["description"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    featured: json["featured"],
    rating: json["rating"],
    overview: json["overview"],
    responsibilities: json["responsibilities"],
    requirememts: json["requirememts"],
    workLocationType: json["work_location_type"],
    address: json["address"],
    startDatetime: json["start_datetime"] == null
        ? null
        : DateTime.parse(json["start_datetime"]),
    expiryDatetime: json["expiry_datetime"] == null
        ? null
        : DateTime.parse(json["expiry_datetime"]),
    periodicity: json["periodicity"],
    tasksMilestones: json["tasks_milestones"],
    nbApplicants: json["nb_applicants"],
    archived: json["archived"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    skills: json["skills"] == null
        ? []
        : List<Skill>.from(json["skills"]!.map((x) => Skill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "member_hashcode": memberHashcode,
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "category_hashcode": categoryHashcode,
    "category_name": categoryName,
    "title": title,
    "image": image,
    "description": description,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "featured": featured,
    "rating": rating,
    "overview": overview,
    "responsibilities": responsibilities,
    "requirememts": requirememts,
    "work_location_type": workLocationType,
    "address": address,
    "start_datetime": startDatetime?.toIso8601String(),
    "expiry_datetime": expiryDatetime?.toIso8601String(),
    "periodicity": periodicity,
    "tasks_milestones": tasksMilestones,
    "nb_applicants": nbApplicants,
    "archived": archived,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "skills": skills == null
        ? []
        : List<dynamic>.from(skills!.map((x) => x.toJson())),
  };
}

class Meta {
  int? page;
  int? last;
  int? size;
  int? total;

  Meta({this.page, this.last, this.size, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    last: json["last"],
    size: json["size"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "last": last,
    "size": size,
    "total": total,
  };
}
