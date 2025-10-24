// To parse this JSON data, do
//
//     final memberProfileResponse = memberProfileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';

import 'JobsResponse.dart';
import 'ServicesResponse.dart' show Service;

MemberProfileResponse memberProfileResponseFromJson(String str) =>
    MemberProfileResponse.fromJson(json.decode(str));

String memberProfileResponseToJson(MemberProfileResponse data) =>
    json.encode(data.toJson());

class MemberProfileResponse {
  bool? success;
  String? message;
  MemberProfile? data;

  MemberProfileResponse({this.success, this.message, this.data});

  factory MemberProfileResponse.fromJson(Map<String, dynamic> json) =>
      MemberProfileResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : MemberProfile.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MemberProfile {
  User? member;
  List<dynamic>? freelancerRatings;
  List<dynamic>? clientRatings;
  List<Skill>? skills;
  List<Service>? services;
  List<Package>? packages;
  List<Job>? jobs;

  MemberProfile({
    this.member,
    this.freelancerRatings,
    this.clientRatings,
    this.skills,
    this.services,
    this.packages,
    this.jobs,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) => MemberProfile(
    member: json["member"] == null ? null : User.fromJson(json["member"]),
    freelancerRatings: json["freelancer_ratings"] == null
        ? []
        : List<dynamic>.from(json["freelancer_ratings"]!.map((x) => x)),
    clientRatings: json["client_ratings"] == null
        ? []
        : List<dynamic>.from(json["client_ratings"]!.map((x) => x)),
    skills: json["skills"] == null
        ? []
        : List<Skill>.from(json["skills"]!.map((x) => Skill.fromJson(x))),
    packages: json["packages"] == null
        ? []
        : List<Package>.from(json["packages"]!.map((x) => Package.fromJson(x))),
    services: json["services"] == null
        ? []
        : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    jobs: json["jobs"] == null
        ? []
        : List<Job>.from(json["jobs"]!.map((x) => Job.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "member": member?.toJson(),
    "freelancer_ratings": freelancerRatings == null
        ? []
        : List<dynamic>.from(freelancerRatings!.map((x) => x)),
    "client_ratings": clientRatings == null
        ? []
        : List<dynamic>.from(clientRatings!.map((x) => x)),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "services": services == null
        ? []
        : List<dynamic>.from(services!.map((x) => x.toJson())),
    "packages": packages == null
        ? []
        : List<dynamic>.from(packages!.map((x) => x)),
    "jobs": jobs == null
        ? []
        : List<dynamic>.from(jobs!.map((x) => x.toJson())),
  };
}
