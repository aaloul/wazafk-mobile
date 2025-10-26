// To parse this JSON data, do
//
//     final employerHomeResponse = employerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/LoginResponse.dart';

EmployerHomeResponse employerHomeResponseFromJson(String str) =>
    EmployerHomeResponse.fromJson(json.decode(str));

String employerHomeResponseToJson(EmployerHomeResponse data) =>
    json.encode(data.toJson());

class EmployerHomeResponse {
  bool? success;
  String? message;
  List<HomeFreelancer>? data;

  EmployerHomeResponse({
    this.success,
    this.message,
    this.data,
  });

  factory EmployerHomeResponse.fromJson(Map<String, dynamic> json) =>
      EmployerHomeResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<HomeFreelancer>.from(
            json["data"]!.map((x) => HomeFreelancer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(
        data!.map((x) => x.toJson())),
  };
}

class HomeFreelancer {
  String? entityType;
  User? member;

  HomeFreelancer({
    this.entityType,
    this.member,
  });

  factory HomeFreelancer.fromJson(Map<String, dynamic> json) => HomeFreelancer(
    entityType: json["entity_type"],
    member: json["member"] == null ? null : User.fromJson(json["member"]),
  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "member": member?.toJson(),
  };
}







