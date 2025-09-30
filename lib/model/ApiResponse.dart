// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  bool? result;
  String? message;
  List<dynamic>? errors;

  ApiResponse({this.result, this.message, this.errors});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    result: json["result"],
    message: json["message"],
    errors: json["errors"] == null
        ? []
        : List<dynamic>.from(json["errors"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
  };
}
