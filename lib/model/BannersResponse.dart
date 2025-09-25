// To parse this JSON data, do
//
//     final bannersResponse = bannersResponseFromJson(jsonString);

import 'dart:convert';

BannersResponse bannersResponseFromJson(String str) =>
    BannersResponse.fromJson(json.decode(str));

String bannersResponseToJson(BannersResponse data) =>
    json.encode(data.toJson());

class BannersResponse {
  bool? success;
  String? message;
  List<Banner>? data;

  BannersResponse({this.success, this.message, this.data});

  factory BannersResponse.fromJson(Map<String, dynamic> json) =>
      BannersResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Banner>.from(json["data"]!.map((x) => Banner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Banner {
  String? hashcode;
  String? title;
  String? description;
  String? source;
  String? type;
  String? area;
  int? order;
  int? status;

  Banner({
    this.hashcode,
    this.title,
    this.description,
    this.source,
    this.type,
    this.area,
    this.order,
    this.status,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    hashcode: json["hashcode"],
    title: json["title"],
    description: json["description"],
    source: json["source"],
    type: json["type"],
    area: json["area"],
    order: json["order"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "title": title,
    "description": description,
    "source": source,
    "type": type,
    "area": area,
    "order": order,
    "status": status,
  };
}
