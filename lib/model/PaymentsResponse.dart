// To parse this JSON data, do
//
//     final paymentsResponse = paymentsResponseFromJson(jsonString);

import 'dart:convert';

PaymentsResponse paymentsResponseFromJson(String str) =>
    PaymentsResponse.fromJson(json.decode(str));

String paymentsResponseToJson(PaymentsResponse data) =>
    json.encode(data.toJson());

class PaymentsResponse {
  bool? success;
  String? message;
  Data? data;

  PaymentsResponse({this.success, this.message, this.data});

  factory PaymentsResponse.fromJson(Map<String, dynamic> json) =>
      PaymentsResponse(
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
  List<Payment>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Payment>.from(json["list"]!.map((x) => Payment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Payment {
  String? hashcode;
  String? method;
  String? code;
  String? amount;
  String? reference;
  String? request;
  DateTime? requestDatetime;
  dynamic response;
  dynamic responseDatetime;
  int? status;

  Payment({
    this.hashcode,
    this.method,
    this.code,
    this.amount,
    this.reference,
    this.request,
    this.requestDatetime,
    this.response,
    this.responseDatetime,
    this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    hashcode: json["hashcode"],
    method: json["method"],
    code: json["code"],
    amount: json["amount"],
    reference: json["reference"],
    request: json["request"],
    requestDatetime: json["request_datetime"] == null
        ? null
        : DateTime.parse(json["request_datetime"]),
    response: json["response"],
    responseDatetime: json["response_datetime"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "method": method,
    "code": code,
    "amount": amount,
    "reference": reference,
    "request": request,
    "request_datetime": requestDatetime?.toIso8601String(),
    "response": response,
    "response_datetime": responseDatetime,
    "status": status,
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
