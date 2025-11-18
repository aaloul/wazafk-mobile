// To parse this JSON data, do
//
//     final notificationsResponse = notificationsResponseFromJson(jsonString);

import 'dart:convert';

NotificationsResponse notificationsResponseFromJson(String str) =>
    NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) =>
    json.encode(data.toJson());

class NotificationsResponse {
  bool? success;
  String? message;
  Data? data;

  NotificationsResponse({this.success, this.message, this.data});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsResponse(
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
  List<NotificationElement>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<NotificationElement>.from(
            json["list"]!.map((x) => NotificationElement.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class NotificationElement {
  String? hashcode;
  DateTime? datetime;
  String? target;
  dynamic reference;
  dynamic referenceHashcode;
  String? channel;
  String? title;
  String? message;
  dynamic actionCode;
  int? isRead;
  dynamic readAt;

  NotificationElement({
    this.hashcode,
    this.datetime,
    this.target,
    this.reference,
    this.referenceHashcode,
    this.channel,
    this.title,
    this.message,
    this.actionCode,
    this.isRead,
    this.readAt,
  });

  factory NotificationElement.fromJson(Map<String, dynamic> json) =>
      NotificationElement(
        hashcode: json["hashcode"],
        datetime: json["datetime"] == null
            ? null
            : DateTime.parse(json["datetime"]),
        target: json["target"],
        reference: json["reference"],
        referenceHashcode: json["reference_hashcode"],
        channel: json["channel"],
        title: json["title"],
        message: json["message"],
        actionCode: json["action_code"],
        isRead: json["is_read"],
        readAt: json["read_at"],
      );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "datetime": datetime?.toIso8601String(),
    "target": target,
    "reference": reference,
    "reference_hashcode": referenceHashcode,
    "channel": channel,
    "title": title,
    "message": message,
    "action_code": actionCode,
    "is_read": isRead,
    "read_at": readAt,
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
