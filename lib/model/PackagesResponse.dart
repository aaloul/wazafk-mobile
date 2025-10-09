// To parse this JSON data, do
//
//     final packagesResponse = packagesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

import 'ServicesResponse.dart';

PackagesResponse packagesResponseFromJson(String str) =>
    PackagesResponse.fromJson(json.decode(str));

String packagesResponseToJson(PackagesResponse data) =>
    json.encode(data.toJson());

class PackagesResponse {
  bool? success;
  String? message;
  Data? data;

  PackagesResponse({this.success, this.message, this.data});

  factory PackagesResponse.fromJson(Map<String, dynamic> json) =>
      PackagesResponse(
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
  List<Package>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Package>.from(json["list"]!.map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Package {
  String? hashcode;
  String? memberHashcode;
  String? memberFirstName;
  String? memberLastName;
  String? title;
  String? image;
  String? description;
  String? unitPrice;
  String? totalPrice;
  int? featured;
  int? availableDuration;
  int? availableBuffer;
  int? status;
  DateTime? createdAt;
  List<Service>? services;
  List<Availability>? availability;

  var checked = false.obs;

  Package({
    this.hashcode,
    this.memberHashcode,
    this.memberFirstName,
    this.memberLastName,
    this.title,
    this.image,
    this.description,
    this.unitPrice,
    this.totalPrice,
    this.featured,
    this.availableDuration,
    this.availableBuffer,
    this.status,
    this.createdAt,
    this.services,
    this.availability,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    hashcode: json["hashcode"],
    memberHashcode: json["member_hashcode"],
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    title: json["title"],
    image: json["image"],
    description: json["description"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    featured: json["featured"],
    availableDuration: json["available_duration"],
    availableBuffer: json["available_buffer"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    services: json["services"] == null
        ? []
        : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    availability: json["availability"] == null
        ? []
        : List<Availability>.from(
            json["availability"]!.map((x) => Availability.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "member_hashcode": memberHashcode,
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "title": title,
    "image": image,
    "description": description,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "featured": featured,
    "available_duration": availableDuration,
    "available_buffer": availableBuffer,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "services": services == null
        ? []
        : List<dynamic>.from(services!.map((x) => x.toJson())),
    "availability": availability == null
        ? []
        : List<dynamic>.from(availability!.map((x) => x.toJson())),
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
