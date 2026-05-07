// To parse this JSON data, do
//
//     final employerHomeResponse = employerHomeResponseFromJson(jsonString);

import 'dart:convert';

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
  Meta? meta;
  List<Service>? records;

  EmployerHome({
    this.meta,
    this.records,
  });

  factory EmployerHome.fromJson(Map<String, dynamic> json) => EmployerHome(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    records: json["list"] == null
        ? []
        : List<Service>.from(
            json["list"]!.map((x) => Service.fromJson(x)),
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
