// To parse this JSON data, do
//
//     final supportCategoriesResponse = supportCategoriesResponseFromJson(jsonString);

import 'dart:convert';

SupportCategoriesResponse supportCategoriesResponseFromJson(String str) => SupportCategoriesResponse.fromJson(json.decode(str));

String supportCategoriesResponseToJson(SupportCategoriesResponse data) => json.encode(data.toJson());

class SupportCategoriesResponse {
  bool? success;
  String? message;
  Data? data;

  SupportCategoriesResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SupportCategoriesResponse.fromJson(Map<String, dynamic> json) => SupportCategoriesResponse(
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
  List<SupportCategory>? list;

  Data({
    this.meta,
    this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null ? [] : List<SupportCategory>.from(json["list"]!.map((x) => SupportCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class SupportCategory {
  String? hashcode;
  String? code;
  String? name;
  String? description;
  int? status;

  SupportCategory({
    this.hashcode,
    this.code,
    this.name,
    this.description,
    this.status,
  });

  factory SupportCategory.fromJson(Map<String, dynamic> json) => SupportCategory(
    hashcode: json["hashcode"],
    code: json["code"],
    name: json["name"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "code": code,
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

  Meta({
    this.page,
    this.last,
    this.size,
    this.total,
  });

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
