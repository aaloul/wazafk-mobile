// To parse this JSON data, do
//
//     final freelancerHomeResponse = freelancerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/JobsResponse.dart';

FreelancerHomeResponse freelancerHomeResponseFromJson(String str) =>
    FreelancerHomeResponse.fromJson(json.decode(str));

String freelancerHomeResponseToJson(FreelancerHomeResponse data) =>
    json.encode(data.toJson());

class FreelancerHomeResponse {
  bool? success;
  String? message;
  FreelancerHome? data;

  FreelancerHomeResponse({this.success, this.message, this.data});

  factory FreelancerHomeResponse.fromJson(Map<String, dynamic> json) =>
      FreelancerHomeResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : FreelancerHome.fromJson(json["data"]),

      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}



class FreelancerHome {
  Meta? meta;
  List<Job>? records;

  FreelancerHome({
    this.meta,
    this.records,
  });

  factory FreelancerHome.fromJson(Map<String, dynamic> json) => FreelancerHome(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    records: json["list"] == null
        ? []
        : List<Job>.from(
      json["list"]!.map((x) => Job.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": records == null
        ? []
        : List<dynamic>.from(records!.map((x) => x.toJson())),
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

