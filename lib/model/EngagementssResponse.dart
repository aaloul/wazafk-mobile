// To parse this JSON data, do
//
//     final engagementsResponse = engagementsResponseFromJson(jsonString);

import 'dart:convert';

import 'AddressesResponse.dart';
import 'JobsResponse.dart';

EngagementsResponse engagementsResponseFromJson(String str) =>
    EngagementsResponse.fromJson(json.decode(str));

String engagementsResponseToJson(EngagementsResponse data) =>
    json.encode(data.toJson());

class EngagementsResponse {
  bool? success;
  String? message;
  Data? data;

  EngagementsResponse({this.success, this.message, this.data});

  factory EngagementsResponse.fromJson(Map<String, dynamic> json) =>
      EngagementsResponse(
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
  List<Engagement>? list;

  Data({this.meta, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null
        ? []
        : List<Engagement>.from(
            json["list"]!.map((x) => Engagement.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null
        ? []
        : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Engagement {
  String? hashcode;
  String? type;
  String? clientHashcode;
  String? clientFirstName;
  String? clientLastName;
  String? freelancerHashcode;
  String? freelancerFirstName;
  String? freelancerLastName;
  Job? job;
  dynamic package;
  List<dynamic>? services;
  int? estimatedHours;
  DateTime? startDatetime;
  DateTime? expiryDatetime;
  String? unitPrice;
  String? totalPrice;
  String? profitAmount;
  String? feesAmount;
  String? commissionFees;
  String? workLocationType;
  Address? address;
  String? description;
  String? tasksMilestones;
  String? messageToClient;
  String? messageToFreelancer;
  String? freelancerCv;
  dynamic completedDatetime;
  dynamic completedDeliverables;
  int? pendingChangeRequest;
  int? hasDispute;
  DateTime? createdAt;
  int? status;

  Engagement({
    this.hashcode,
    this.type,
    this.clientHashcode,
    this.clientFirstName,
    this.clientLastName,
    this.freelancerHashcode,
    this.freelancerFirstName,
    this.freelancerLastName,
    this.job,
    this.package,
    this.services,
    this.estimatedHours,
    this.startDatetime,
    this.expiryDatetime,
    this.unitPrice,
    this.totalPrice,
    this.profitAmount,
    this.feesAmount,
    this.commissionFees,
    this.workLocationType,
    this.address,
    this.description,
    this.tasksMilestones,
    this.messageToClient,
    this.messageToFreelancer,
    this.freelancerCv,
    this.completedDatetime,
    this.completedDeliverables,
    this.pendingChangeRequest,
    this.hasDispute,
    this.createdAt,
    this.status,
  });

  factory Engagement.fromJson(Map<String, dynamic> json) => Engagement(
    hashcode: json["hashcode"],
    type: json["type"],
    clientHashcode: json["client_hashcode"],
    clientFirstName: json["client_first_name"],
    clientLastName: json["client_last_name"],
    freelancerHashcode: json["freelancer_hashcode"],
    freelancerFirstName: json["freelancer_first_name"],
    freelancerLastName: json["freelancer_last_name"],
    job: json["job"] == null ? null : Job.fromJson(json["job"]),
    package: json["package"],
    services: json["services"] == null
        ? []
        : List<dynamic>.from(json["services"]!.map((x) => x)),
    estimatedHours: json["estimated_hours"],
    startDatetime: json["start_datetime"] == null
        ? null
        : DateTime.parse(json["start_datetime"]),
    expiryDatetime: json["expiry_datetime"] == null
        ? null
        : DateTime.parse(json["expiry_datetime"]),
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    profitAmount: json["profit_amount"],
    feesAmount: json["fees_amount"],
    commissionFees: json["commission_fees"],
    workLocationType: json["work_location_type"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    description: json["description"],
    tasksMilestones: json["tasks_milestones"],
    messageToClient: json["message_to_client"],
    messageToFreelancer: json["message_to_freelancer"],
    freelancerCv: json["freelancer_cv"],
    completedDatetime: json["completed_datetime"],
    completedDeliverables: json["completed_deliverables"],
    pendingChangeRequest: json["pending_change_request"],
    hasDispute: json["has_dispute"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "type": type,
    "client_hashcode": clientHashcode,
    "client_first_name": clientFirstName,
    "client_last_name": clientLastName,
    "freelancer_hashcode": freelancerHashcode,
    "freelancer_first_name": freelancerFirstName,
    "freelancer_last_name": freelancerLastName,
    "job": job?.toJson(),
    "package": package,
    "services": services == null
        ? []
        : List<dynamic>.from(services!.map((x) => x)),
    "estimated_hours": estimatedHours,
    "start_datetime": startDatetime?.toIso8601String(),
    "expiry_datetime": expiryDatetime?.toIso8601String(),
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "profit_amount": profitAmount,
    "fees_amount": feesAmount,
    "commission_fees": commissionFees,
    "work_location_type": workLocationType,
    "address": address?.toJson(),
    "description": description,
    "tasks_milestones": tasksMilestones,
    "message_to_client": messageToClient,
    "message_to_freelancer": messageToFreelancer,
    "freelancer_cv": freelancerCv,
    "completed_datetime": completedDatetime,
    "completed_deliverables": completedDeliverables,
    "pending_change_request": pendingChangeRequest,
    "has_dispute": hasDispute,
    "created_at": createdAt?.toIso8601String(),
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
