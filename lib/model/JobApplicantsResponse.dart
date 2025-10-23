// To parse this JSON data, do
//
//     final jobApplicantsResponse = jobApplicantsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/LoginResponse.dart';

import 'EngagementsResponse.dart';

JobApplicantsResponse jobApplicantsResponseFromJson(String str) =>
    JobApplicantsResponse.fromJson(json.decode(str));

String jobApplicantsResponseToJson(JobApplicantsResponse data) =>
    json.encode(data.toJson());

class JobApplicantsResponse {
  bool? success;
  String? message;
  List<JobApplicant>? data;

  JobApplicantsResponse({this.success, this.message, this.data});

  factory JobApplicantsResponse.fromJson(Map<String, dynamic> json) =>
      JobApplicantsResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<JobApplicant>.from(
                json["data"]!.map((x) => JobApplicant.fromJson(x)),
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

class JobApplicant {
  Engagement? engagement;
  User? applicant;

  JobApplicant({this.engagement, this.applicant});

  factory JobApplicant.fromJson(Map<String, dynamic> json) => JobApplicant(
    engagement: json["engagement"] == null
        ? null
        : Engagement.fromJson(json["engagement"]),
    applicant: json["applicant"] == null
        ? null
        : User.fromJson(json["applicant"]),
  );

  Map<String, dynamic> toJson() => {
    "engagement": engagement?.toJson(),
    "applicant": applicant?.toJson(),
  };
}
