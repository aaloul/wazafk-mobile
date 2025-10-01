// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  bool? success;
  String? message;
  List<dynamic>? errors;

  ApiResponse({this.success, this.message, this.errors});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    success: json["success"],
    message: json["message"],
    errors: json["errors"] == null
        ? []
        : List<dynamic>.from(json["errors"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
  };
}
