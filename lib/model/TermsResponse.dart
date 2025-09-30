// To parse this JSON data, do
//
//     final termsResponse = termsResponseFromJson(jsonString);

import 'dart:convert';

TermsResponse termsResponseFromJson(String str) =>
    TermsResponse.fromJson(json.decode(str));

String termsResponseToJson(TermsResponse data) => json.encode(data.toJson());

class TermsResponse {
  bool? success;
  String? message;
  PageData? data;

  TermsResponse({this.success, this.message, this.data});

  factory TermsResponse.fromJson(Map<String, dynamic> json) => TermsResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class PageData {
  String? hashcode;
  String? page;
  String? title;
  String? content;
  int? status;

  PageData({this.hashcode, this.page, this.title, this.content, this.status});

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
    hashcode: json["hashcode"],
    page: json["page"],
    title: json["title"],
    content: json["content"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "page": page,
    "title": title,
    "content": content,
    "status": status,
  };
}
