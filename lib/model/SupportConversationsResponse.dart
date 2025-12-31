// To parse this JSON data, do
//
//     final supportConversationsResponse = supportConversationsResponseFromJson(jsonString);

import 'dart:convert';

SupportConversationsResponse supportConversationsResponseFromJson(String str) => SupportConversationsResponse.fromJson(json.decode(str));

String supportConversationsResponseToJson(SupportConversationsResponse data) => json.encode(data.toJson());

class SupportConversationsResponse {
  bool? success;
  String? message;
  Data? data;

  SupportConversationsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SupportConversationsResponse.fromJson(Map<String, dynamic> json) => SupportConversationsResponse(
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
  Meta? meta;
  List<SupportConversation>? list;

  Data({
    this.meta,
    this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null ? [] : List<SupportConversation>.from(json["list"]!.map((x) => SupportConversation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class SupportConversation {
  String? hashcode;
  int? group;
  List<GroupParticipant>? groupParticipants;
  String? memberFirstName;
  String? memberLastName;
  String? categoryHashcode;
  String? categoryName;
  String? channelName;
  String? subject;
  String? reference;
  String? referenceHashcode;
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
    groupParticipants: json["group_participants"] == null ? [] : List<GroupParticipant>.from(json["group_participants"]!.map((x) => GroupParticipant.fromJson(x))),
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
    "group_participants": groupParticipants == null ? [] : List<dynamic>.from(groupParticipants!.map((x) => x.toJson())),
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

class GroupParticipant {
  String? memberFirstName;
  String? memberLastName;
  String? memberImage;

  GroupParticipant({
    this.memberFirstName,
    this.memberLastName,
    this.memberImage,
  });

  factory GroupParticipant.fromJson(Map<String, dynamic> json) => GroupParticipant(
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    memberImage: json["member_image"],
  );

  Map<String, dynamic> toJson() => {
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "member_image": memberImage,
  };
}

class Meta {
  int? page;
  int? last;
  int? size;
  int? total;

  Meta({
    this.page,
    this.last,
    this.size,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    last: json["last"],
    size: json["size"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "last": last,
    "size": size,
    "total": total,
  };
}
