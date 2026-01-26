// To parse this JSON data, do
//
//     final areasResponse = areasResponseFromJson(jsonString);

import 'dart:convert';

AreasResponse areasResponseFromJson(String str) => AreasResponse.fromJson(json.decode(str));

String areasResponseToJson(AreasResponse data) => json.encode(data.toJson());

class AreasResponse {
  bool? success;
  String? message;
  List<AreaModel>? data;

  AreasResponse({
    this.success,
    this.message,
    this.data,
  });

  factory AreasResponse.fromJson(Map<String, dynamic> json) => AreasResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AreaModel>.from(json["data"]!.map((x) => AreaModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AreaModel {
  String? code;
  String? name;

  AreaModel({
    this.code,
    this.name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
    code: json["code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };
}
