import 'dart:convert';

RateBulkRequest rateBulkRequestFromJson(String str) =>
    RateBulkRequest.fromJson(json.decode(str));

String rateBulkRequestToJson(RateBulkRequest data) =>
    json.encode(data.toJson());

class RateBulkRequest {
  String? target;
  String? rateMember;
  String? ratingByCriteria;
  String? comment;
  List<RateServiceRequest>? rateServices;
  List<RateJobRequest>? rateJobs;

  RateBulkRequest({
    this.target,
    this.rateMember,
    this.ratingByCriteria,
    this.comment,
    this.rateServices,
    this.rateJobs,
  });

  factory RateBulkRequest.fromJson(Map<String, dynamic> json) =>
      RateBulkRequest(
        target: json["target"],
        rateMember: json["rate_member"],
        ratingByCriteria: json["rating_by_criteria"],
        comment: json["comment"],
        rateServices: json["rate_services"] == null
            ? []
            : List<RateServiceRequest>.from(
                json["rate_services"]!.map((x) => RateServiceRequest.fromJson(x)),
              ),
        rateJobs: json["rate_jobs"] == null
            ? []
            : List<RateJobRequest>.from(
                json["rate_jobs"]!.map((x) => RateJobRequest.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "target": target,
        "rate_member": rateMember,
        "rating_by_criteria": ratingByCriteria,
        "comment": comment,
        "rate_services": rateServices == null
            ? []
            : List<dynamic>.from(rateServices!.map((x) => x.toJson())),
        "rate_jobs": rateJobs == null
            ? []
            : List<dynamic>.from(rateJobs!.map((x) => x.toJson())),
      };
}

class RateServiceRequest {
  String? service;
  String? ratingByCriteria;
  String? comment;

  RateServiceRequest({
    this.service,
    this.ratingByCriteria,
    this.comment,
  });

  factory RateServiceRequest.fromJson(Map<String, dynamic> json) =>
      RateServiceRequest(
        service: json["service"],
        ratingByCriteria: json["rating_by_criteria"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "rating_by_criteria": ratingByCriteria,
        "comment": comment,
      };
}

class RateJobRequest {
  String? job;
  String? ratingByCriteria;
  String? comment;

  RateJobRequest({
    this.job,
    this.ratingByCriteria,
    this.comment,
  });

  factory RateJobRequest.fromJson(Map<String, dynamic> json) =>
      RateJobRequest(
        job: json["job"],
        ratingByCriteria: json["rating_by_criteria"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "job": job,
        "rating_by_criteria": ratingByCriteria,
        "comment": comment,
      };
}
