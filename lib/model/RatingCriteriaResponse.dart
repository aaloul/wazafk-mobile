// To parse this JSON data, do
//
//     final ratingCriteriaResponse = ratingCriteriaResponseFromJson(jsonString);

import 'dart:convert';

RatingCriteriaResponse ratingCriteriaResponseFromJson(String str) =>
    RatingCriteriaResponse.fromJson(json.decode(str));

String ratingCriteriaResponseToJson(RatingCriteriaResponse data) =>
    json.encode(data.toJson());

class RatingCriteriaResponse {
  bool? success;
  String? message;
  List<RatingCriteria>? data;

  RatingCriteriaResponse({this.success, this.message, this.data});

  factory RatingCriteriaResponse.fromJson(Map<String, dynamic> json) =>
      RatingCriteriaResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<RatingCriteria>.from(
                json["data"]!.map((x) => RatingCriteria.fromJson(x)),
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

class RatingCriteria {
  String? hashcode;
  String? code;
  String? target;
  String? name;
  String? description;
  int? status;

  RatingCriteria({
    this.hashcode,
    this.code,
    this.target,
    this.name,
    this.description,
    this.status,
  });

  factory RatingCriteria.fromJson(Map<String, dynamic> json) => RatingCriteria(
    hashcode: json["hashcode"],
    code: json["code"],
    target: json["target"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "code": code,
    "target": target,
    "name": name,
    "description": description,
    "status": status,
  };
}
