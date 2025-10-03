// To parse this JSON data, do
//
//     final skillsResponse = skillsResponseFromJson(jsonString);

import 'dart:convert';

SkillsResponse skillsResponseFromJson(String str) =>
    SkillsResponse.fromJson(json.decode(str));

String skillsResponseToJson(SkillsResponse data) => json.encode(data.toJson());

class SkillsResponse {
  bool? success;
  String? message;
  Data? data;

  SkillsResponse({this.success, this.message, this.data});

  factory SkillsResponse.fromJson(Map<String, dynamic> json) => SkillsResponse(
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
  List<Skill>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Skill>.from(json["list"]!.map((x) => Skill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Skill {
  String? hashcode;
  String? code;
  String? categoryHashcode;
  String? categoryName;
  String? name;
  String? description;
  int? status;

  Skill({
    this.hashcode,
    this.code,
    this.categoryHashcode,
    this.categoryName,
    this.name,
    this.description,
    this.status,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    hashcode: json["hashcode"],
    code: json["code"],
    categoryHashcode: json["category_hashcode"],
    categoryName: json["category_name"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "code": code,
    "category_hashcode": categoryHashcode,
    "category_name": categoryName,
    "name": name,
    "description": description,
    "status": status,
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
