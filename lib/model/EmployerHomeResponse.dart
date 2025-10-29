// To parse this JSON data, do
//
//     final employerHomeResponse = employerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/LoginResponse.dart';

import 'PackagesResponse.dart';
import 'ServicesResponse.dart';

EmployerHomeResponse employerHomeResponseFromJson(String str) =>
    EmployerHomeResponse.fromJson(json.decode(str));

String employerHomeResponseToJson(EmployerHomeResponse data) =>
    json.encode(data.toJson());

class EmployerHomeResponse {
  bool? success;
  String? message;
  List<EmployerHomeData>? data;

  EmployerHomeResponse({
    this.success,
    this.message,
    this.data,
  });actory EmployerHomeResponse.fromJson(Map<String, dynamic> json) =>
      EmployerHomeResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<EmployerHomeData>.from(
                json["data"]!.map((x) => EmployerHomeData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(
        data!.map((x) => x.toJson())),
  };
}

class EmployerHomeData {
  String? entityType;
  User? member;
  Service? service;
  Package? package;

  EmployerHomeData({
    this.entityType,
    this.member,
    this.service,
    this.package,
  });

  factory EmployerHomeData.fromJson(Map<String, dynamic> json) =>
      EmployerHomeData(
    entityType: json["entity_type"],
    member: json["member"] == null ? null : User.fromJson(json["member"]),
        service: json["service"] == null ? null : Service.fromJson(
            json["service"]),
        package: json["package"] == null ? null : Package.fromJson(
            json["package"]),
  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "member": member?.toJson(),
    "service": service?.toJson(),
    "package": package?.toJson(),
  };
}

