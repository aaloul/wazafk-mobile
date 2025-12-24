// To parse this JSON data, do
//
//     final supportStartConversationResponse = supportStartConversationResponseFromJson(jsonString);

import 'dart:convert';

SupportStartConversationResponse supportStartConversationResponseFromJson(String str) => SupportStartConversationResponse.fromJson(json.decode(str));

String supportStartConversationResponseToJson(SupportStartConversationResponse data) => json.encode(data.toJson());

class SupportStartConversationResponse {
  bool? success;
  String? message;
  SupportConversation? data;

  SupportStartConversationResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SupportStartConversationResponse.fromJson(Map<String, dynamic> json) => SupportStartConversationResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : SupportConversation.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class SupportConversation {
  String? hashcode;
  dynamic group;
  List<dynamic>? groupParticipants;
  String? memberFirstName;
  String? memberLastName;
  String? categoryHashcode;
  String? categoryName;
  String? channelName;
  String? subject;
  dynamic reference;
  dynamic referenceHashcode;
  int? status;
  DateTime? createdAt;

  SupportConversation({
    this.hashcode,
    this.group,
    this.groupParticipants,
    this.memberFirstName,
    this.memberLastName,
    this.categoryHashcode,
    this.categoryName,
    this.channelName,
    this.subject,
    this.reference,
    this.referenceHashcode,
    this.status,
    this.createdAt,
  });

  factory SupportConversation.fromJson(Map<String, dynamic> json) => SupportConversation(
    hashcode: json["hashcode"],
    group: json["group"],
    groupParticipants: json["group_participants"] == null ? [] : List<dynamic>.from(json["group_participants"]!.map((x) => x)),
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    categoryHashcode: json["category_hashcode"],
    categoryName: json["category_name"],
    channelName: json["channel_name"],
    subject: json["subject"],
    reference: json["reference"],
    referenceHashcode: json["reference_hashcode"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "group": group,
    "group_participants": groupParticipants == null ? [] : List<dynamic>.from(groupParticipants!.map((x) => x)),
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "category_hashcode": categoryHashcode,
    "category_name": categoryName,
    "channel_name": channelName,
    "subject": subject,
    "reference": reference,
    "reference_hashcode": referenceHashcode,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
  };
}
