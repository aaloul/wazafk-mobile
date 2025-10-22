// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/LoginResponse.dart';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  bool? success;
  String? message;
  Data? data;

  ProfileResponse({this.success, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
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
  User? member;
  dynamic totalEarnings;
  dynamic nbActiveJobs;
  dynamic nbCompletedJobs;
  dynamic successRate;

  Data({
    this.member,
    this.totalEarnings,
    this.nbActiveJobs,
    this.nbCompletedJobs,
    this.successRate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    member: json["member"] == null ? null : User.fromJson(json["member"]),
    totalEarnings: json["total_earnings"],
    nbActiveJobs: json["nb_active_jobs"],
    nbCompletedJobs: json["nb_completed_jobs"],
    successRate: json["success_rate"],
  );

  Map<String, dynamic> toJson() => {
    "member": member?.toJson(),
    "total_earnings": totalEarnings,
    "nb_active_jobs": nbActiveJobs,
    "nb_completed_jobs": nbCompletedJobs,
    "success_rate": successRate,
  };
}
