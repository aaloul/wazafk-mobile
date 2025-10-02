// To parse this JSON data, do
//
//     final faqsResponse = faqsResponseFromJson(jsonString);

import 'dart:convert';

FaqsResponse faqsResponseFromJson(String str) =>
    FaqsResponse.fromJson(json.decode(str));

String faqsResponseToJson(FaqsResponse data) => json.encode(data.toJson());

class FaqsResponse {
  bool? success;
  String? message;
  List<Faq>? data;

  FaqsResponse({this.success, this.message, this.data});

  factory FaqsResponse.fromJson(Map<String, dynamic> json) => FaqsResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Faq>.from(json["data"]!.map((x) => Faq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Faq {
  String? hashcode;
  dynamic category;
  String? question;
  String? answer;
  int? order;
  int? status;

  Faq({
    this.hashcode,
    this.category,
    this.question,
    this.answer,
    this.order,
    this.status,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    hashcode: json["hashcode"],
    category: json["category"],
    question: json["question"],
    answer: json["answer"],
    order: json["order"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "category": category,
    "question": question,
    "answer": answer,
    "order": order,
    "status": status,
  };
}
