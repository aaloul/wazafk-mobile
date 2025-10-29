// To parse this JSON data, do
//
//     final favoritesResponse = favoritesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';

import 'PackagesResponse.dart';
import 'ServicesResponse.dart';

FavoritesResponse favoritesResponseFromJson(String str) =>
    FavoritesResponse.fromJson(json.decode(str));

String favoritesResponseToJson(FavoritesResponse data) =>
    json.encode(data.toJson());

class FavoritesResponse {
  bool? success;
  String? message;
  List<FavoriteData>? data;

  FavoritesResponse({this.success, this.message, this.data});

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) =>
      FavoritesResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<FavoriteData>.from(
            json["data"]!.map((x) => FavoriteData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(
        data!.map((x) => x.toJson())),
  };
}

class FavoriteData {
  String? entityType;
  Service? service;
  Package? package;
  User? member;
  Job? job;

  FavoriteData({
    this.entityType,
    this.service,
    this.package,
    this.member,
    this.job,
  });

  factory FavoriteData.fromJson(Map<String, dynamic> json) =>
      FavoriteData(
        entityType: json["entity_type"],
        service: json["service"] == null ? null : Service.fromJson(
            json["service"]),
        package: json["package"] == null ? null : Package.fromJson(
            json["package"]),
        member: json["member"] == null ? null : User.fromJson(json["member"]),
        job: json["job"] == null ? null : Job.fromJson(json["job"]),
  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "service": service?.toJson(),
    "package": package?.toJson(),
    "member": member?.toJson(),
    "job": job?.toJson(),
  };
}
