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
  DataCounts? messagingUnreadCounts;
  dynamic totalEarnings;
  dynamic nbActiveJobs;
  dynamic nbCompletedJobs;
  dynamic successRate;

  Data({
    this.member,
    this.messagingUnreadCounts,
    this.totalEarnings,
    this.nbActiveJobs,
    this.nbCompletedJobs,
    this.successRate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    member: json["member"] == null ? null : User.fromJson(json["member"]),
    messagingUnreadCounts: json["messaging_unread_counts"] == null ? null : DataCounts.fromJson(json["messaging_unread_counts"]),
    totalEarnings: json["total_earnings"],
    nbActiveJobs: json["nb_active_jobs"],
    nbCompletedJobs: json["nb_completed_jobs"],
    successRate: json["success_rate"],
  );

  Map<String, dynamic> toJson() => {
    "member": member?.toJson(),
    "messaging_unread_counts": messagingUnreadCounts?.toJson(),
    "total_earnings": totalEarnings,
    "nb_active_jobs": nbActiveJobs,
    "nb_completed_jobs": nbCompletedJobs,
    "success_rate": successRate,
  };
}

class DataCounts {
  dynamic notificationsCount;
  dynamic chatMessagesCount;
  dynamic supportMessagesCount;

  DataCounts({
    this.notificationsCount,
    this.chatMessagesCount,
    this.supportMessagesCount,
  });

  factory DataCounts.fromJson(Map<String, dynamic> json) => DataCounts(
    notificationsCount: json["notifications_count"],
    chatMessagesCount: json["chat_messages_count"],
    supportMessagesCount: json["support_messages_count"],
  );

  Map<String, dynamic> toJson() => {
    "notifications_count": notificationsCount,
    "chat_messages_count": chatMessagesCount,
    "support_messages_count": supportMessagesCount,
  };
}


