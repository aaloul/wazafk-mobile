// To parse this JSON data, do
//
//     final verifyGuestResponse = verifyGuestResponseFromJson(jsonString);

import 'dart:convert';

VerifyGuestResponse verifyGuestResponseFromJson(String str) =>
    VerifyGuestResponse.fromJson(json.decode(str));

String verifyGuestResponseToJson(VerifyGuestResponse data) =>
    json.encode(data.toJson());

class VerifyGuestResponse {
  bool? success;
  String? message;
  Data? data;

  VerifyGuestResponse({this.success, this.message, this.data});

  factory VerifyGuestResponse.fromJson(Map<String, dynamic> json) =>
      VerifyGuestResponse(
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
  String? verifyToken;

  Data({this.verifyToken});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(verifyToken: json["verify_token"]);

  Map<String, dynamic> toJson() => {"verify_token": verifyToken};
}
