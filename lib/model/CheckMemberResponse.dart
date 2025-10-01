// To parse this JSON data, do
//
//     final checkMemberResponse = checkMemberResponseFromJson(jsonString);

import 'dart:convert';

CheckMemberResponse checkMemberResponseFromJson(String str) =>
    CheckMemberResponse.fromJson(json.decode(str));

String checkMemberResponseToJson(CheckMemberResponse data) =>
    json.encode(data.toJson());

class CheckMemberResponse {
  bool? success;
  String? message;
  Data? data;

  CheckMemberResponse({this.success, this.message, this.data});

  factory CheckMemberResponse.fromJson(Map<String, dynamic> json) =>
      CheckMemberResponse(
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
  bool? exists;

  Data({this.exists});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(exists: json["exists"]);

  Map<String, dynamic> toJson() => {"exists": exists};
}
