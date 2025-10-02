// To parse this JSON data, do
//
//     final memberSkillsResponse = memberSkillsResponseFromJson(jsonString);

import 'dart:convert';

MemberSkillsResponse memberSkillsResponseFromJson(String str) =>
    MemberSkillsResponse.fromJson(json.decode(str));

String memberSkillsResponseToJson(MemberSkillsResponse data) =>
    json.encode(data.toJson());

class MemberSkillsResponse {
  bool? success;
  String? message;
  List<MemberSkill>? data;

  MemberSkillsResponse({this.success, this.message, this.data});

  factory MemberSkillsResponse.fromJson(Map<String, dynamic> json) =>
      MemberSkillsResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MemberSkill>.from(
                json["data"]!.map((x) => MemberSkill.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MemberSkill {
  String? categoryHashcode;
  String? categoryName;
  String? name;
  String? description;

  MemberSkill({
    this.categoryHashcode,
    this.categoryName,
    this.name,
    this.description,
  });

  factory MemberSkill.fromJson(Map<String, dynamic> json) => MemberSkill(
    categoryHashcode: json["category_hashcode"],
    categoryName: json["category_name"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "category_hashcode": categoryHashcode,
    "category_name": categoryName,
    "name": name,
    "description": description,
  };
}
