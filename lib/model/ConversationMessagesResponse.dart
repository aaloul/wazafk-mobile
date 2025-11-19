// To parse this JSON data, do
//
//     final conversationMessagesResponse = conversationMessagesResponseFromJson(jsonString);

import 'dart:convert';

ConversationMessagesResponse conversationMessagesResponseFromJson(String str) =>
    ConversationMessagesResponse.fromJson(json.decode(str));

String conversationMessagesResponseToJson(ConversationMessagesResponse data) =>
    json.encode(data.toJson());

class ConversationMessagesResponse {
  bool? success;
  String? message;
  Data? data;

  ConversationMessagesResponse({this.success, this.message, this.data});

  factory ConversationMessagesResponse.fromJson(Map<String, dynamic> json) =>
      ConversationMessagesResponse(
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
  List<ConversationMessage>? list;
  ConversationEventDetails? conversationEventDetails;

  Data({this.meta, this.list, this.conversationEventDetails});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<ConversationMessage>.from(
            json["list"]!.map((x) => ConversationMessage.fromJson(x)),
          ),
    conversationEventDetails: json["conversation_event_details"] == null
        ? null
        : ConversationEventDetails.fromJson(json["conversation_event_details"]),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
    "conversation_event_details": conversationEventDetails?.toJson(),
  };
}

class ConversationEventDetails {
  String? channelName;
  String? eventListenerName;

  ConversationEventDetails({this.channelName, this.eventListenerName});

  factory ConversationEventDetails.fromJson(Map<String, dynamic> json) =>
      ConversationEventDetails(
        channelName: json["channel_name"],
        eventListenerName: json["event_listener_name"],
      );

  Map<String, dynamic> toJson() => {
    "channel_name": channelName,
    "event_listener_name": eventListenerName,
  };
}

class ConversationMessage {
  String? messageHashcode;
  String? message;
  String? senderHashcode;
  String? senderPhoto;
  String? receiverHashcode;
  String? receiverPhoto;
  String? reference;
  int? read;
  DateTime? createdAt;

  ConversationMessage({
    this.messageHashcode,
    this.message,
    this.senderHashcode,
    this.senderPhoto,
    this.receiverHashcode,
    this.receiverPhoto,
    this.reference,
    this.read,
    this.createdAt,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) =>
      ConversationMessage(
        messageHashcode: json["message_hashcode"],
        message: json["message"],
        senderHashcode: json["sender_hashcode"],
        senderPhoto: json["sender_photo"],
        receiverHashcode: json["receiver_hashcode"],
        receiverPhoto: json["receiver_photo"],
        reference: json["reference"],
        read: json["read"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toUtc(),
      );

  Map<String, dynamic> toJson() => {
    "message_hashcode": messageHashcode,
    "message": message,
    "sender_hashcode": senderHashcode,
    "sender_photo": senderPhoto,
    "receiver_hashcode": receiverHashcode,
    "receiver_photo": receiverPhoto,
    "reference": reference,
    "read": read,
    "created_at": createdAt?.toIso8601String(),
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
