// To parse this JSON data, do
//
//     final supportConversationMessagesResponse = supportConversationMessagesResponseFromJson(jsonString);

import 'dart:convert';

SupportConversationMessagesResponse supportConversationMessagesResponseFromJson(String str) => SupportConversationMessagesResponse.fromJson(json.decode(str));

String supportConversationMessagesResponseToJson(SupportConversationMessagesResponse data) => json.encode(data.toJson());

class SupportConversationMessagesResponse {
  bool? success;
  String? message;
  Data? data;

  SupportConversationMessagesResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SupportConversationMessagesResponse.fromJson(Map<String, dynamic> json) => SupportConversationMessagesResponse(
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
  List<SupportConversationMessage>? list;

  Data({
    this.meta,
    this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null ? [] : List<SupportConversationMessage>.from(json["list"]!.map((x) => SupportConversationMessage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class SupportConversationMessage {
  String? hashcode;
  String? conversationHashcode;
  String? senderType;
  String? memberFirstName;
  String? memberLastName;
  String? message;
  String? attachmentType;
  String? attachmentUrl;
  dynamic attachmentMetadata;
  int? read;
  int? status;
  DateTime? createdAt;

  SupportConversationMessage({
    this.hashcode,
    this.conversationHashcode,
    this.senderType,
    this.memberFirstName,
    this.memberLastName,
    this.message,
    this.attachmentType,
    this.attachmentUrl,
    this.attachmentMetadata,
    this.read,
    this.status,
    this.createdAt,
  });

  factory SupportConversationMessage.fromJson(Map<String, dynamic> json) => SupportConversationMessage(
    hashcode: json["hashcode"],
    conversationHashcode: json["conversation_hashcode"],
    senderType: json["sender_type"],
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    message: json["message"],
    attachmentType: json["attachment_type"],
    attachmentUrl: json["attachment"],
    attachmentMetadata: json["attachment_metadata"],
    read: json["read"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "conversation_hashcode": conversationHashcode,
    "sender_type": senderType,
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "message": message,
    "attachment_type": attachmentType,
    "attachment": attachmentUrl,
    "attachment_metadata": attachmentMetadata,
    "read": read,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
  };

  // Helper methods
  bool get hasAttachment => attachmentType != null && attachmentUrl != null;
  bool get isImage => attachmentType == 'image';
  bool get isVideo => attachmentType == 'video';
  bool get isVoice => attachmentType == 'voice';
  bool get isDocument => attachmentType == 'document';
  bool get isFile => attachmentType == 'file';

  // Get file name from URL
  String get fileName {
    if (attachmentUrl == null) return 'Attachment';
    final uri = Uri.tryParse(attachmentUrl!);
    if (uri == null) return 'Attachment';
    final segments = uri.pathSegments;
    if (segments.isEmpty) return 'Attachment';
    return segments.last;
  }

  // Get file extension from URL
  String get fileExtension {
    final name = fileName;
    final parts = name.split('.');
    if (parts.length < 2) return '';
    return parts.last.toLowerCase();
  }

  // Check if file is audio based on extension
  bool get isAudio {
    final audioExtensions = [
      'm4a', 'mp3', 'wav', 'aac', 'ogg', 'opus', 'flac', 'wma', 'amr'
    ];
    return isVoice || audioExtensions.contains(fileExtension);
  }
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
