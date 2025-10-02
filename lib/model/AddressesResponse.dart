// To parse this JSON data, do
//
//     final addressesResponse = addressesResponseFromJson(jsonString);

import 'dart:convert';

AddressesResponse addressesResponseFromJson(String str) =>
    AddressesResponse.fromJson(json.decode(str));

String addressesResponseToJson(AddressesResponse data) =>
    json.encode(data.toJson());

class AddressesResponse {
  bool? success;
  String? message;
  List<Address>? data;

  AddressesResponse({this.success, this.message, this.data});

  factory AddressesResponse.fromJson(Map<String, dynamic> json) =>
      AddressesResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Address>.from(json["data"]!.map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Address {
  String? hashcode;
  String? label;
  String? city;
  String? address;
  String? street;
  String? building;
  String? apartment;
  String? latitude;
  String? longitude;
  int? datumDefault;

  Address({
    this.hashcode,
    this.label,
    this.city,
    this.address,
    this.street,
    this.building,
    this.apartment,
    this.latitude,
    this.longitude,
    this.datumDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    hashcode: json["hashcode"],
    label: json["label"],
    city: json["city"],
    address: json["address"],
    street: json["street"],
    building: json["building"],
    apartment: json["apartment"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    datumDefault: json["default"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "label": label,
    "city": city,
    "address": address,
    "street": street,
    "building": building,
    "apartment": apartment,
    "latitude": latitude,
    "longitude": longitude,
    "default": datumDefault,
  };
}
