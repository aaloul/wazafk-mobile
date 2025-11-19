// To parse this JSON data, do
//
//     final contactsResponse = contactsResponseFromJson(jsonString);

import 'dart:convert';

ContactsResponse contactsResponseFromJson(String str) =>
    ContactsResponse.fromJson(json.decode(str));

String contactsResponseToJson(ContactsResponse data) =>
    json.encode(data.toJson());

class ContactsResponse {
  bool? success;
  String? message;
  Data? data;

  ContactsResponse({this.success, this.message, this.data});

  factory ContactsResponse.fromJson(Map<String, dynamic> json) =>
      ContactsResponse(
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
  List<ContactElement>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<ContactElement>.from(
            json["list"]!.map((x) => ContactElement.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ContactElement {
  String? hashcode;
  String? code;
  String? title;
  String? firstName;
  String? lastName;
  String? image;
  String? channelName;
  String? eventListenerName;

  ContactElement({
    this.hashcode,
    this.code,
    this.title,
    this.firstName,
    this.lastName,
    this.image,
    this.channelName,
    this.eventListenerName,
  });

  factory ContactElement.fromJson(Map<String, dynamic> json) => ContactElement(
    hashcode: json["hashcode"],
    code: json["code"],
    title: json["title"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    channelName: json["channel_name"],
    eventListenerName: json["event_listener_name"],
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
