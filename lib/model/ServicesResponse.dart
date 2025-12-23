// To parse this JSON data, do
//
//     final servicesResponse = servicesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

import 'SkillsResponse.dart';

ServicesResponse servicesResponseFromJson(String str) =>
    ServicesResponse.fromJson(json.decode(str));

String servicesResponseToJson(ServicesResponse data) =>
    json.encode(data.toJson());

class ServicesResponse {
  bool? success;
  String? message;
  Data? data;

  ServicesResponse({this.success, this.message, this.data});

  factory ServicesResponse.fromJson(Map<String, dynamic> json) =>
      ServicesResponse(
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
  List<Service>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Service>.from(json["list"]!.map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Service {
  String? hashcode;
  String? memberHashcode;
  String? memberFirstName;
  String? memberLastName;
  String? categoryHashcode;
  String? parentCategoryHashcode;
  String? parentCategoryName;
  String? categoryName;
  String? title;
  String? rating;

  // String? image;
  String? description;
  String? unitPrice;
  String? pricingType;
  String? totalPrice;
  String? portfolio;
  int? featured;
  String? experience;
  int? availableDuration;
  int? availableBuffer;
  int? status;
  DateTime? createdAt;
  List<Skill>? skills;
  List<Area>? areas;
  List<Availability>? availability;
  bool? isFavorite;
  String? memberImage;
  String? memberRating;
  String? memberTitle;

  var checked = false.obs;

  Service({
    this.hashcode,
    this.memberHashcode,
    this.memberFirstName,
    this.memberLastName,
    this.categoryHashcode,
    this.parentCategoryHashcode,
    this.parentCategoryName,
    this.categoryName,
    this.title,
    this.rating,
    // this.image,
    this.description,
    this.pricingType,
    this.unitPrice,
    this.totalPrice,
    this.portfolio,
    this.featured,
    this.experience,
    this.availableDuration,
    this.availableBuffer,
    this.status,
    this.createdAt,
    this.skills,
    this.areas,
    this.availability,
    this.isFavorite,
    this.memberImage,
    this.memberRating,
    this.memberTitle,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    hashcode: json["hashcode"],
    memberHashcode: json["member_hashcode"],
    memberFirstName: json["member_first_name"],
    memberLastName: json["member_last_name"],
    pricingType: json["pricing_type"],
    categoryHashcode: json["category_hashcode"],
    parentCategoryHashcode: json["parent_category_hashcode"],
    parentCategoryName: json["parent_category_name"],
    categoryName: json["category_name"],
    title: json["title"],
    rating: json["rating"],
    // image: json["image"],
    description: json["description"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    portfolio: json["portfolio"],
    featured: json["featured"],
    experience: json["experience"],
    availableDuration: json["available_duration"],
    availableBuffer: json["available_buffer"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    skills: json["skills"] == null
        ? []
        : List<Skill>.from(json["skills"]!.map((x) => Skill.fromJson(x))),
    areas: json["areas"] == null
        ? []
        : List<Area>.from(json["areas"]!.map((x) => Area.fromJson(x))),
    availability: json["availability"] == null
        ? []
        : List<Availability>.from(
            json["availability"]!.map((x) => Availability.fromJson(x)),
          ),
    isFavorite: json["is_favorite"],
    memberImage: json["member_image"],
    memberRating: json["member_rating"],
    memberTitle: json["member_title"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "member_hashcode": memberHashcode,
    "member_first_name": memberFirstName,
    "member_last_name": memberLastName,
    "category_hashcode": categoryHashcode,
    "parent_category_hashcode": parentCategoryHashcode,
    "parent_category_name": parentCategoryName,
    "category_name": categoryName,
    "title": title,
    "rating": rating,
    "pricing_type": pricingType,
    // "image": image,
    "description": description,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "portfolio": portfolio,
    "featured": featured,
    "experience": experience,
    "available_duration": availableDuration,
    "available_buffer": availableBuffer,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "skills": skills == null
        ? []
        : List<dynamic>.from(skills!.map((x) => x.toJson())),
    "areas": areas == null
        ? []
        : List<dynamic>.from(areas!.map((x) => x.toJson())),
    "availability": availability == null
        ? []
        : List<dynamic>.from(availability!.map((x) => x.toJson())),
    "is_favorite": isFavorite,
    "member_image": memberImage,
    "member_title": memberTitle,
    "member_rating": memberRating,
  };
}

class Area {
  String? hashcode;
  String? label;
  String? city;
  String? address;
  String? street;
  String? building;
  String? apartment;
  String? latitude;
  String? longitude;
  int? areaDefault;

  Area({
    this.hashcode,
    this.label,
    this.city,
    this.address,
    this.street,
    this.building,
    this.apartment,
    this.latitude,
    this.longitude,
    this.areaDefault,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    hashcode: json["hashcode"],
    label: json["label"],
    city: json["city"],
    address: json["address"],
    street: json["street"],
    building: json["building"],
    apartment: json["apartment"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    areaDefault: json["default"],
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
    "default": areaDefault,
  };
}

class Availability {
  String? hashcode;
  String? day;
  String? startTime;
  String? endTime;

  Availability({this.hashcode, this.day, this.startTime, this.endTime});

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    hashcode: json["hashcode"],
    day: json["day"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "day": day,
    "start_time": startTime,
    "end_time": endTime,
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
