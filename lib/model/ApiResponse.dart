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

  /// Whatever the endpoint returned under `data`, untyped — some actions (like
  /// submitting an engagement) hand back the record they just created.
  dynamic data;

  ApiResponse({this.success, this.message, this.errors, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"],
    errors: json["errors"] == null
        ? []
        : List<dynamic>.from(json["errors"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
  };
}
