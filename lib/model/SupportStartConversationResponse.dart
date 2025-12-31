// To parse this JSON data, do
//
//     final supportStartConversationResponse = supportStartConversationResponseFromJson(jsonString);

import 'dart:convert';

import 'SupportConversationsResponse.dart';

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
