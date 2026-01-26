// To parse this JSON data, do
//
//     final engagementsResponse = engagementsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';

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

  EngagementsResponse({
    this.success,
    this.message,
    this.data,
  });

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

  Data({
    this.meta,
    this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    list: json["list"] == null ? [] : List<Engagement>.from(
        json["list"]!.map((x) => Engagement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "list": list == null ? [] : List<dynamic>.from(
        list!.map((x) => x.toJson())),
  };
}

class Engagement {
  String? entityType;
  bool? isMemberRated;
  bool? isSubjectRated;
  String? subjectToRate;
  String? hashcode;
  String? type;
  String? clientHashcode;
  String? clientRating;
  String? freelancerRating;
  String? clientFirstName;
  String? clientTitle;
  String? clientLastName;
  String? clientImage;
  String? freelancerHashcode;
  String? freelancerTitle;
  String? freelancerFirstName;
  String? freelancerLastName;
  String? freelancerImage;
  Job? job;
  Package? package;
  List<Service>? services;
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
  DateTime? completedDatetime;
  String? completedDeliverables;
  int? pendingChangeRequest;
  int? hasDispute;
  DateTime? createdAt;
  int? status;
  String? statusCode;
  String? statusLabel;
  String? statusColor;
  String? statusPendingAction;
  String? progress;
  dynamic remaining;
  List<ChangeRequest>? changeRequests;

  Engagement({
    this.entityType,
    this.isMemberRated,
    this.isSubjectRated,
    this.subjectToRate,
    this.hashcode,
    this.clientRating,
    this.freelancerRating,
    this.type,
    this.clientHashcode,
    this.clientFirstName,
    this.clientLastName,
    this.clientImage,
    this.clientTitle,
    this.freelancerHashcode,
    this.freelancerFirstName,
    this.freelancerLastName,
    this.freelancerImage,
    this.freelancerTitle,
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
    this.statusCode,
    this.statusLabel,
    this.statusColor,
    this.statusPendingAction,
    this.progress,
    this.remaining,
    this.changeRequests,
  });

  factory Engagement.fromJson(Map<String, dynamic> json) => Engagement(
    entityType: json["entity_type"],
    isMemberRated: json["is_member_rated"],
    isSubjectRated: json["is_subject_rated"],
    subjectToRate: json["subject_to_rate"],
    hashcode: json["hashcode"],
    type: json["type"],
    freelancerRating: json["freelancer_rating"],
    clientRating: json["client_rating"],
    clientHashcode: json["client_hashcode"],
    clientFirstName: json["client_first_name"],
    clientTitle: json["client_title"],
    freelancerTitle: json["freelancer_title"],
    clientLastName: json["client_last_name"],
    clientImage: json["client_image"],
    freelancerHashcode: json["freelancer_hashcode"],
    freelancerFirstName: json["freelancer_first_name"],
    freelancerLastName: json["freelancer_last_name"],
    freelancerImage: json["freelancer_image"],
    job: json["job"] == null ? null : Job.fromJson(json["job"]),
    package: json["package"] == null ? null : Package.fromJson(json["package"]),
    services: json["services"] == null ? [] : List<Service>.from(
        json["services"]!.map((x) => Service.fromJson(x))),
    estimatedHours: json["estimated_hours"],
    startDatetime: json["start_datetime"] == null ? null : DateTime.parse(
        json["start_datetime"]),
    expiryDatetime: json["expiry_datetime"] == null ? null : DateTime.parse(
        json["expiry_datetime"]),
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
    completedDatetime: json["completed_datetime"] == null ? null : DateTime
        .parse(json["completed_datetime"]),
    completedDeliverables: json["completed_deliverables"],
    pendingChangeRequest: json["pending_change_request"],
    hasDispute: json["has_dispute"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(
        json["created_at"]),
    status: json["status"],
    statusCode: json["status_code"],
    statusLabel: json["status_label"],
    statusColor: json["status_color"],
    statusPendingAction: json["status_pending_action"],
    progress: json["progress"],
    remaining: json["remaining"],
    changeRequests: json["change_requests"] == null ? [] : List<
        ChangeRequest>.from(
        json["change_requests"]!.map((x) => ChangeRequest.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "is_member_rated": isMemberRated,
    "is_subject_rated": isSubjectRated,
    "subject_to_rate": subjectToRate,
    "hashcode": hashcode,
    "type": type,
    "client_rating": clientRating,
    "freelancer_rating": freelancerRating,
    "client_title": clientTitle,
    "freelancer_title": freelancerTitle,
    "client_hashcode": clientHashcode,
    "client_first_name": clientFirstName,
    "client_last_name": clientLastName,
    "freelancer_hashcode": freelancerHashcode,
    "freelancer_first_name": freelancerFirstName,
    "freelancer_last_name": freelancerLastName,
    "job": job?.toJson(),
    "package": package,
    "services": services == null ? [] : List<dynamic>.from(
        services!.map((x) => x)),
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
    "completed_datetime": completedDatetime?.toIso8601String(),
    "completed_deliverables": completedDeliverables,
    "pending_change_request": pendingChangeRequest,
    "has_dispute": hasDispute,
    "created_at": createdAt?.toIso8601String(),
    "status": status,
    "status_code": statusCode,
    "status_label": statusLabel,
    "status_color": statusColor,
    "status_pending_action": statusPendingAction,
    "progress": progress,
    "remaining": remaining,
    "change_requests": changeRequests == null ? [] : List<dynamic>.from(
        changeRequests!.map((x) => x.toJson())),

  };
}


class ChangeRequest {
  String? hashcode;
  String? engagementHashcode;
  String? requester;
  String? requesterHashcode;
  String? requesterFirstName;
  String? requesterLastName;
  String? receiverHashcode;
  String? receiverFirstName;
  String? receiverLastName;
  String? changedFields;
  String? message;
  int? estimatedHours;
  DateTime? startDatetime;
  DateTime? expiryDatetime;
  dynamic unitPrice;
  dynamic totalPrice;
  dynamic profitAmount;
  dynamic feesAmount;
  DateTime? createdAt;
  int? status;

  ChangeRequest({
    this.hashcode,
    this.engagementHashcode,
    this.message,
    this.requester,
    this.requesterHashcode,
    this.requesterFirstName,
    this.requesterLastName,
    this.receiverHashcode,
    this.receiverFirstName,
    this.receiverLastName,
    this.changedFields,
    this.estimatedHours,
    this.startDatetime,
    this.expiryDatetime,
    this.unitPrice,
    this.totalPrice,
    this.profitAmount,
    this.feesAmount,
    this.createdAt,
    this.status,
  });

  factory ChangeRequest.fromJson(Map<String, dynamic> json) =>
      ChangeRequest(
        hashcode: json["hashcode"],
        engagementHashcode: json["engagement_hashcode"],
        message: json["message"],
        requester: json["requester"],
        requesterHashcode: json["requester_hashcode"],
        requesterFirstName: json["requester_first_name"],
        requesterLastName: json["requester_last_name"],
        receiverHashcode: json["receiver_hashcode"],
        receiverFirstName: json["receiver_first_name"],
        receiverLastName: json["receiver_last_name"],
        changedFields: json["changed_fields"],
        estimatedHours: json["estimated_hours"],
        startDatetime: json["start_datetime"] == null ? null : DateTime.parse(
            json["start_datetime"]),
        expiryDatetime: json["expiry_datetime"] == null ? null : DateTime.parse(
            json["expiry_datetime"]),
        unitPrice: json["unit_price"],
        totalPrice: json["total_price"],
        profitAmount: json["profit_amount"],
        feesAmount: json["fees_amount"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {
        "hashcode": hashcode,
        "engagement_hashcode": engagementHashcode,
        "requester": requester,
        "message": message,
        "requester_hashcode": requesterHashcode,
        "requester_first_name": requesterFirstName,
        "requester_last_name": requesterLastName,
        "receiver_hashcode": receiverHashcode,
        "receiver_first_name": receiverFirstName,
        "receiver_last_name": receiverLastName,
        "changed_fields": changedFields,
        "estimated_hours": estimatedHours,
        "start_datetime": startDatetime?.toIso8601String(),
        "expiry_datetime": expiryDatetime?.toIso8601String(),
        "unit_price": unitPrice,
        "total_price": totalPrice,
        "profit_amount": profitAmount,
        "fees_amount": feesAmount,
        "created_at": createdAt?.toIso8601String(),
        "status": status,
  };
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
