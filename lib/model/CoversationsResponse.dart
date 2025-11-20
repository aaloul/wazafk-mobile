// To parse this JSON data, do
//
//     final coversationsResponse = coversationsResponseFromJson(jsonString);

import 'dart:convert';

CoversationsResponse coversationsResponseFromJson(String str) =>
    CoversationsResponse.fromJson(json.decode(str));

String coversationsResponseToJson(CoversationsResponse data) =>
    json.encode(data.toJson());

class CoversationsResponse {
  bool? success;
  String? message;
  Data? data;

  CoversationsResponse({this.success, this.message, this.data});

  factory CoversationsResponse.fromJson(Map<String, dynamic> json) =>
      CoversationsResponse(
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
  List<Coversation>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Coversation>.from(
            json["list"]!.map((x) => Coversation.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Coversation {
  String? hashcode;
  String? code;
  String? title;
  String? firstName;
  String? lastName;
  String? image;
  String? channelName;
  String? eventListenerName;
  LastMessage? lastMessage;

  Coversation({
    this.hashcode,
    this.code,
    this.title,
    this.firstName,
    this.lastName,
    this.image,
    this.channelName,
    this.eventListenerName,
    this.lastMessage,
  });

  factory Coversation.fromJson(Map<String, dynamic> json) => Coversation(
    hashcode: json["hashcode"],
    code: json["code"],
    title: json["title"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    channelName: json["channel_name"],
    eventListenerName: json["event_listener_name"],
    lastMessage: json["last_message"] == null
        ? null
        : LastMessage.fromJson(json["last_message"]),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "code": code,
    "title": title,
    "first_name": firstName,
    "last_name": lastName,
    "image": image,
    "channel_name": channelName,
    "event_listener_name": eventListenerName,
    "last_message": lastMessage?.toJson(),
  };
}

class LastMessage {
  String? messageHashcode;
  String? message;
  String? reference;
  DateTime? createdAt;
  int? read;

  LastMessage({
    this.messageHashcode,
    this.message,
    this.reference,
    this.createdAt,
    this.read,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    messageHashcode: json["message_hashcode"],
    message: json["message"],
    reference: json["reference"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    read: json["read"],
  );

  Map<String, dynamic> toJson() => {
    "message_hashcode": messageHashcode,
    "message": message,
    "reference": reference,
    "created_at": createdAt?.toIso8601String(),
    "read": read,
  };
}

class Meta {
  int? page;
  int? last;
  int? size;
  int? total;

  Meta({this.page, this.last, this.size, this.total});

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
