// To parse this JSON data, do
//
//     final interestOptionsResponse = interestOptionsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

InterestOptionsResponse interestOptionsResponseFromJson(String str) => InterestOptionsResponse.fromJson(json.decode(str));

String interestOptionsResponseToJson(InterestOptionsResponse data) => json.encode(data.toJson());

class InterestOptionsResponse {
  bool? success;
  String? message;
  List<InterestOption>? data;

  InterestOptionsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory InterestOptionsResponse.fromJson(Map<String, dynamic> json) => InterestOptionsResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<InterestOption>.from(json["data"]!.map((x) => InterestOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class InterestOption {
  String? hashcode;
  String? code;
  String? name;
  String? icon;
  int? order;
  int? status;
  var selected = false.obs;

  InterestOption({
    this.hashcode,
    this.code,
    this.name,
    this.icon,
    this.order,
    this.status,
  });

  factory InterestOption.fromJson(Map<String, dynamic> json) => InterestOption(
    hashcode: json["hashcode"],
    code: json["code"],
    name: json["name"],
    icon: json["icon"],
    order: json["order"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "code": code,
    "name": name,
    "icon": icon,
    "order": order,
    "status": status,
  };
}
