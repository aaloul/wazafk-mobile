// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) =>
    CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) =>
    json.encode(data.toJson());

class CategoriesResponse {
  bool? success;
  String? message;
  Data? data;

  CategoriesResponse({this.success, this.message, this.data});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
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
  List<Category>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Category>.from(json["list"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Category {
  String? hashcode;
  String? code;
  dynamic parentHashcode;
  dynamic parentName;
  String? name;
  String? icon;
  String? description;
  String? type;
  bool? hasSubCategories;
  int? status;

  @override
  String toString() {
    return name.toString();
  }

  Category({
    this.hashcode,
    this.code,
    this.parentHashcode,
    this.parentName,
    this.name,
    this.icon,
    this.description,
    this.type,
    this.hasSubCategories,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    hashcode: json["hashcode"],
    code: json["code"],
    parentHashcode: json["parent_hashcode"],
    parentName: json["parent_name"],
    name: json["name"],
    icon: json["icon"],
    description: json["description"],
    type: json["type"],
    hasSubCategories: json["has_subCategories"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "code": code,
    "parent_hashcode": parentHashcode,
    "parent_name": parentName,
    "name": name,
    "icon": icon,
    "description": description,
    "type": type,
    "has_subCategories": hasSubCategories,
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
