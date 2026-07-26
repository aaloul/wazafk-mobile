// To parse this JSON data, do
//
//     final employerHomeResponse = employerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';

import 'PackagesResponse.dart';
import 'ServicesResponse.dart';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String employerHomeResponseToJson(SearchResponse data) =>
    json.encode(data.toJson());

class SearchResponse {
  bool? success;
  String? message;
  Data? data;

  SearchResponse({this.success, this.message, this.data});

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
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
  int? page;
  int? pageLimit;
  dynamic prevIndices;
  String? pageIndices;
  int? total;
  List<SearchData>? records;

  Data({
    this.page,
    this.pageLimit,
    this.prevIndices,
    this.pageIndices,
    this.total,
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // The search endpoint may return the list under "records" (search v2) or
    // "list" (same envelope as the home endpoints). Accept either so results
    // render regardless of which the backend sends.
    final dynamic rawList = json["records"] ?? json["list"];
    final Map<String, dynamic>? meta =
        json["meta"] is Map<String, dynamic> ? json["meta"] : null;
    return Data(
      page: json["page"] ?? meta?["page"],
      pageLimit: json["page_limit"] ?? meta?["size"],
      prevIndices: json["prev_indices"],
      pageIndices: json["page_indices"],
      total: json["total"] ?? meta?["total"],
      records: rawList == null
          ? []
          : List<SearchData>.from(rawList.map((x) => SearchData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "page": page,
        "page_limit": pageLimit,
        "prev_indices": prevIndices,
        "page_indices": pageIndices,
        "total": total,
        "records": records == null ? [] : List<dynamic>.from(
            records!.map((x) => x.toJson())),
      };
}


class SearchData {
  String? entityType;
  User? member;
  Service? service;
  Package? package;
  Job? job;

  SearchData({
    this.entityType,
    this.member,
    this.service,
    this.package,
    this.job,
  });

  /// Search records arrive in one of two shapes:
  ///
  ///  * an envelope — `{"entity_type": "JOB", "job": {…}}`;
  ///  * the entity itself, with the type inlined —
  ///    `{"entity_type": "JOB", "hashcode": …, "title": …}`, which is what the
  ///    v2 search endpoints return.
  ///
  /// Both are accepted here, and the type is matched case-insensitively; when
  /// it is missing entirely the shape of the record decides.
  factory SearchData.fromJson(Map<String, dynamic> json) {
    final type = _normalizeType(json["entity_type"] ?? json["type"]);

    final hasEnvelope = json["member"] is Map ||
        json["service"] is Map ||
        json["package"] is Map ||
        json["job"] is Map;

    if (hasEnvelope) {
      return SearchData(
        entityType: type,
        member:
            json["member"] == null ? null : User.fromJson(json["member"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        package:
            json["package"] == null ? null : Package.fromJson(json["package"]),
        job: json["job"] == null ? null : Job.fromJson(json["job"]),
      );
    }

    final resolved = type ?? _guessType(json);
    switch (resolved) {
      case 'MEMBER':
        return SearchData(entityType: resolved, member: User.fromJson(json));
      case 'PACKAGE':
        return SearchData(entityType: resolved, package: Package.fromJson(json));
      case 'JOB':
        return SearchData(entityType: resolved, job: Job.fromJson(json));
      case 'SERVICE':
        return SearchData(entityType: resolved, service: Service.fromJson(json));
      default:
        return SearchData(entityType: resolved);
    }
  }

  static String? _normalizeType(dynamic raw) {
    if (raw == null) return null;
    switch (raw.toString().toUpperCase()) {
      case 'MEMBER':
      case 'FREELANCER':
      case 'USER':
        return 'MEMBER';
      case 'PACKAGE':
      case 'PACK':
        return 'PACKAGE';
      case 'JOB':
        return 'JOB';
      case 'SERVICE':
        return 'SERVICE';
      default:
        return raw.toString().toUpperCase();
    }
  }

  /// Last resort when the payload carries no type: pick it from the keys that
  /// only one entity has.
  static String? _guessType(Map<String, dynamic> json) {
    if (json.containsKey('first_name') || json.containsKey('last_name')) {
      return 'MEMBER';
    }
    if (json.containsKey('overview') ||
        json.containsKey('responsibilities') ||
        json.containsKey('requirememts') ||
        json.containsKey('start_datetime')) {
      return 'JOB';
    }
    if (json['services'] is List) return 'PACKAGE';
    if (json.containsKey('pricing_type') ||
        json.containsKey('experience') ||
        json['packages'] is List) {
      return 'SERVICE';
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "member": member?.toJson(),
    "service": service?.toJson(),
    "package": package?.toJson(),
    "job": job?.toJson(),
  };
}
