// To parse this JSON data, do
//
//     final walletResponse = walletResponseFromJson(jsonString);

import 'dart:convert';

WalletResponse walletResponseFromJson(String str) =>
    WalletResponse.fromJson(json.decode(str));

String walletResponseToJson(WalletResponse data) => json.encode(data.toJson());

class WalletResponse {
  bool? success;
  String? message;
  Data? data;

  WalletResponse({this.success, this.message, this.data});

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
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
  String? hashcode;
  String? type;
  String? code;
  String? memberHashcode;
  String? memberFirstName;
  String? memberLastName;
  String? name;
  String? balance;
  String? blockedAmount;
  int? status;

  Data({
    this.hashcode,
    this.type,
    this.code,
    this.memberHashcode,
    this.memberFirstName,
    this.memberLastName,
    this.name,
    this.balance,
    this.blockedAmount,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    hashcode: json["hashcode"],
    type: json["type"],
    code: json["code"],
    memberHashcode: json["member_hashcode"],
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    name: json["name"],
    balance: json["balance"],
    blockedAmount: json["blocked_amount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "type": type,
    "code": code,
    "member_hashcode": memberHashcode,
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "name": name,
    "balance": balance,
    "blocked_amount": blockedAmount,
    "status": status,
  };
}
