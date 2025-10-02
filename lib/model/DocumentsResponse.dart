// To parse this JSON data, do
//
//     final documentsResponse = documentsResponseFromJson(jsonString);

import 'dart:convert';

DocumentsResponse documentsResponseFromJson(String str) =>
    DocumentsResponse.fromJson(json.decode(str));

String documentsResponseToJson(DocumentsResponse data) =>
    json.encode(data.toJson());

class DocumentsResponse {
  bool? success;
  String? message;
  List<Document>? data;

  DocumentsResponse({this.success, this.message, this.data});

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) =>
      DocumentsResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Document>.from(
                json["data"]!.map((x) => Document.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Document {
  String? hashcode;
  String? type;
  String? document1;
  String? document2;
  String? reason;
  int? status;

  Document({
    this.hashcode,
    this.type,
    this.document1,
    this.document2,
    this.reason,
    this.status,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    hashcode: json["hashcode"],
    type: json["type"],
    document1: json["document_1"],
    document2: json["document_2"],
    reason: json["reason"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "type": type,
    "document_1": document1,
    "document_2": document2,
    "reason": reason,
    "status": status,
  };
}
