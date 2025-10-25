// To parse this JSON data, do
//
//     final memberReviewsResponse = memberReviewsResponseFromJson(jsonString);

import 'dart:convert';

MemberReviewsResponse memberReviewsResponseFromJson(String str) =>
    MemberReviewsResponse.fromJson(json.decode(str));

String memberReviewsResponseToJson(MemberReviewsResponse data) =>
    json.encode(data.toJson());

class MemberReviewsResponse {
  bool? success;
  String? message;
  List<MemberReview>? data;

  MemberReviewsResponse({this.success, this.message, this.data});

  factory MemberReviewsResponse.fromJson(Map<String, dynamic> json) =>
      MemberReviewsResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MemberReview>.from(
                json["data"]!.map((x) => MemberReview.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MemberReview {
  String? hashcode;
  String? memberFirstName;
  String? memberLastName;
  String? target;
  int? rating;
  String? comment;
  DateTime? createdAt;

  MemberReview({
    this.hashcode,
    this.memberFirstName,
    this.memberLastName,
    this.target,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory MemberReview.fromJson(Map<String, dynamic> json) => MemberReview(
    hashcode: json["hashcode"],
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    target: json["target"],
    rating: json["rating"],
    comment: json["comment"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "target": target,
    "rating": rating,
    "comment": comment,
    "created_at": createdAt?.toIso8601String(),
  };
}
