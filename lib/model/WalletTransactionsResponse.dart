// To parse this JSON data, do
//
//     final walletTransactionsResponse = walletTransactionsResponseFromJson(jsonString);

import 'dart:convert';

WalletTransactionsResponse walletTransactionsResponseFromJson(String str) =>
    WalletTransactionsResponse.fromJson(json.decode(str));

String walletTransactionsResponseToJson(WalletTransactionsResponse data) =>
    json.encode(data.toJson());

class WalletTransactionsResponse {
  bool? success;
  String? message;
  Data? data;

  WalletTransactionsResponse({this.success, this.message, this.data});

  factory WalletTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      WalletTransactionsResponse(
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
  List<Transaction>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Transaction>.from(
            json["list"]!.map((x) => Transaction.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Transaction {
  String? hashcode;
  String? wallet;
  String? memberHashcode;
  String? code;
  String? type;
  String? action;
  String? amount;
  String? details;
  String? target;
  String? reason;
  DateTime? createdAt;

  Transaction({
    this.hashcode,
    this.wallet,
    this.memberHashcode,
    this.code,
    this.type,
    this.action,
    this.amount,
    this.details,
    this.target,
    this.reason,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    hashcode: json["hashcode"],
    wallet: json["wallet"],
    memberHashcode: json["member_hashcode"],
    code: json["code"],
    type: json["type"],
    action: json["action"],
    amount: json["amount"],
    details: json["details"],
    target: json["target"],
    reason: json["reason"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "wallet": wallet,
    "member_hashcode": memberHashcode,
    "code": code,
    "type": type,
    "action": action,
    "amount": amount,
    "details": details,
    "target": target,
    "reason": reason,
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
