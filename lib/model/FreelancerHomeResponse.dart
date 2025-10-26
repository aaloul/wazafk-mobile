// To parse this JSON data, do
//
//     final freelancerHomeResponse = freelancerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/JobsResponse.dart';

FreelancerHomeResponse freelancerHomeResponseFromJson(String str) =>
    FreelancerHomeResponse.fromJson(json.decode(str));

String freelancerHomeResponseToJson(FreelancerHomeResponse data) =>
    json.encode(data.toJson());

class FreelancerHomeResponse {
  bool? success;
  String? message;
  List<Job>? data;

  FreelancerHomeResponse({this.success, this.message, this.data});

  factory FreelancerHomeResponse.fromJson(Map<String, dynamic> json) =>
      FreelancerHomeResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Job>.from(json["data"]!.map((x) => Job.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
