// To parse this JSON data, do
//
//     final employerHomeResponse = employerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';

import 'PackagesResponse.dart';
import 'ServicesResponse.dart';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String employerHomeResponseToJson(SearchResponse data) =>
    json.encode(data.toJson());

class SearchResponse {
  bool? success;
  String? message;
  Data? data;

  SearchResponse({this.success, this.message, this.data});

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
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
  int? page;
  int? pageLimit;
  dynamic prevIndices;
  String? pageIndices;
  int? total;
  List<SearchData>? records;

  Data({
    this.page,
    this.pageLimit,
    this.prevIndices,
    this.pageIndices,
    this.total,
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        page: json["page"],
        pageLimit: json["page_limit"],
        prevIndices: json["prev_indices"],
        pageIndices: json["page_indices"],
        total: json["total"],
        records: json["records"] == null ? [] : List<SearchData>.from(
            json["records"]!.map((x) => SearchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "page": page,
        "page_limit": pageLimit,
        "prev_indices": prevIndices,
        "page_indices": pageIndices,
        "total": total,
        "records": records == null ? [] : List<dynamic>.from(
            records!.map((x) => x.toJson())),
      };
}


class SearchData {
  String? entityType;
  User? member;
  Service? service;
  Package? package;
  Job? job;

  SearchData({
    this.entityType,
    this.member,
    this.service,
    this.package,
    this.job,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    entityType: json["entity_type"],
    member: json["member"] == null ? null : User.fromJson(json["member"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    package: json["package"] == null ? null : Package.fromJson(json["package"]),
    job: json["job"] == null ? null : Job.fromJson(json["job"]),
  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "member": member?.toJson(),
    "service": service?.toJson(),
    "package": package?.toJson(),
    "job": job?.toJson(),
  };
}
