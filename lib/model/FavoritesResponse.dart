// To parse this JSON data, do
//
//     final favoritesResponse = favoritesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/LoginResponse.dart';

import 'JobsResponse.dart';

FavoritesResponse favoritesResponseFromJson(String str) =>
    FavoritesResponse.fromJson(json.decode(str));

String favoritesResponseToJson(FavoritesResponse data) =>
    json.encode(data.toJson());

class FavoritesResponse {
  bool? success;
  String? message;
  Data? data;

  FavoritesResponse({this.success, this.message, this.data});

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) =>
      FavoritesResponse(
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
  List<User>? members;
  List<Job>? jobs;

  Data({this.members, this.jobs});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    members: json["members"] == null
        ? []
        : List<User>.from(json["members"]!.map((x) => User.fromJson(x))),
    jobs: json["jobs"] == null
        ? []
        : List<Job>.from(json["jobs"]!.map((x) => Job.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "members": members == null
        ? []
        : List<dynamic>.from(members!.map((x) => x.toJson())),
    "jobs": jobs == null
        ? []
        : List<dynamic>.from(jobs!.map((x) => x.toJson())),
  };
}
