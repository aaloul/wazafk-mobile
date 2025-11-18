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
  EmployerHome? data;

  EmployerHomeResponse({this.success, this.message, this.data});

  factory EmployerHomeResponse.fromJson(Map<String, dynamic> json) =>
      EmployerHomeResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : EmployerHome.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class EmployerHome {
  int? page;
  int? pageLimit;
  int? total;
  String? prevIndices;
  String? pageIndices;
  List<EmployerHomeData>? records;

  EmployerHome({
    this.page,
    this.pageLimit,
    this.prevIndices,
    this.pageIndices,
    this.total,
    this.records,
  });

  factory EmployerHome.fromJson(Map<String, dynamic> json) => EmployerHome(
    page: json["page"],
    pageLimit: json["page_limit"],
    prevIndices: json["prev_indices"],
    pageIndices: json["page_indices"],
    total: json["total"],
    records: json["records"] == null
        ? []
        : List<EmployerHomeData>.from(
            json["records"]!.map((x) => EmployerHomeData.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "page_limit": pageLimit,
    "prev_indices": prevIndices,
    "page_indices": pageIndices,
    "total": total,
    "records": records == null
        ? []
        : List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class EmployerHomeData {
  String? entityType;
  User? member;
  Service? service;
  Package? package;

  EmployerHomeData({this.entityType, this.member, this.service, this.package});

  factory EmployerHomeData.fromJson(
    Map<String, dynamic> json,
  ) => EmployerHomeData(
    entityType: json["entity_type"],
    member: json["member"] == null ? null : User.fromJson(json["member"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    package: json["package"] == null ? null : Package.fromJson(json["package"]),
  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "member": member?.toJson(),
    "service": service?.toJson(),
    "package": package?.toJson(),
  };
}
