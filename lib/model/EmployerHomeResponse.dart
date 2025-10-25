// To parse this JSON data, do
//
//     final employerHomeResponse = employerHomeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wazafak_app/model/JobsResponse.dart';

import 'PackagesResponse.dart';
import 'ServicesResponse.dart';

EmployerHomeResponse employerHomeResponseFromJson(String str) =>
    EmployerHomeResponse.fromJson(json.decode(str));

String employerHomeResponseToJson(EmployerHomeResponse data) =>
    json.encode(data.toJson());

class EmployerHomeResponse {
  bool? success;
  String? message;
  List<HomeFreelancer>? data;

  EmployerHomeResponse({this.success, this.message, this.data});

  factory EmployerHomeResponse.fromJson(Map<String, dynamic> json) =>
      EmployerHomeResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<HomeFreelancer>.from(
                json["data"]!.map((x) => HomeFreelancer.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HomeFreelancer {
  String? entityType;
  String? hashcode;
  String? code;
  String? title;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  DateTime? dateOfBirth;
  String? gender;
  String? image;
  String? country;
  String? info;
  dynamic workExperience;
  String? website;
  String? rating;
  DateTime? joinDate;
  String? joinYear;
  String? timezone;
  String? language;
  int? idVerified;
  dynamic idVerifiedDatetime;
  dynamic documentType;
  String? document1;
  String? document2;
  String? documentPassport;
  String? documentForeignLegal1;
  String? documentForeignLegal2;
  String? documentForeignPaperwork;
  int? status;
  dynamic nbJobPosts;
  dynamic nbHiredFreelancers;
  int? nbCompletedJobs;
  int? isFavorite;
  List<Service>? services;
  List<Package>? packages;
  List<Job>? jobPosts;

  HomeFreelancer({
    this.entityType,
    this.hashcode,
    this.code,
    this.title,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.image,
    this.country,
    this.info,
    this.workExperience,
    this.website,
    this.rating,
    this.joinDate,
    this.joinYear,
    this.timezone,
    this.language,
    this.idVerified,
    this.idVerifiedDatetime,
    this.documentType,
    this.document1,
    this.document2,
    this.documentPassport,
    this.documentForeignLegal1,
    this.documentForeignLegal2,
    this.documentForeignPaperwork,
    this.status,
    this.nbJobPosts,
    this.nbHiredFreelancers,
    this.nbCompletedJobs,
    this.isFavorite,
    this.services,
    this.packages,
    this.jobPosts,
  });

  factory HomeFreelancer.fromJson(Map<String, dynamic> json) => HomeFreelancer(
    entityType: json["entity_type"],
    hashcode: json["hashcode"],
    code: json["code"],
    title: json["title"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    mobile: json["mobile"],
    email: json["email"],
    dateOfBirth: json["date_of_birth"] == null
        ? null
        : DateTime.parse(json["date_of_birth"]),
    gender: json["gender"],
    image: json["image"],
    country: json["country"],
    info: json["info"],
    workExperience: json["work_experience"],
    website: json["website"],
    rating: json["rating"],
    joinDate: json["join_date"] == null
        ? null
        : DateTime.parse(json["join_date"]),
    joinYear: json["join_year"],
    timezone: json["timezone"],
    language: json["language"],
    idVerified: json["id_verified"],
    idVerifiedDatetime: json["id_verified_datetime"],
    documentType: json["document_type"],
    document1: json["document_1"],
    document2: json["document_2"],
    documentPassport: json["document_passport"],
    documentForeignLegal1: json["document_foreign_legal_1"],
    documentForeignLegal2: json["document_foreign_legal_2"],
    documentForeignPaperwork: json["document_foreign_paperwork"],
    status: json["status"],
    nbJobPosts: json["nb_job_posts"],
    nbHiredFreelancers: json["nb_hired_freelancers"],
    nbCompletedJobs: json["nb_completed_jobs"],
    isFavorite: json["is_favorite"],
    services: json["services"] == null
        ? []
        : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    packages: json["packages"] == null
        ? []
        : List<Package>.from(json["packages"]!.map((x) => Package.fromJson(x))),
    jobPosts: json["job_posts"] == null
        ? []
        : List<Job>.from(json["job_posts"]!.map((x) => Job.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "hashcode": hashcode,
    "code": code,
    "title": title,
    "first_name": firstName,
    "last_name": lastName,
    "mobile": mobile,
    "email": email,
    "date_of_birth":
        "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "image": image,
    "country": country,
    "info": info,
    "work_experience": workExperience,
    "website": website,
    "rating": rating,
    "join_date": joinDate?.toIso8601String(),
    "join_year": joinYear,
    "timezone": timezone,
    "language": language,
    "id_verified": idVerified,
    "id_verified_datetime": idVerifiedDatetime,
    "document_type": documentType,
    "document_1": document1,
    "document_2": document2,
    "document_passport": documentPassport,
    "document_foreign_legal_1": documentForeignLegal1,
    "document_foreign_legal_2": documentForeignLegal2,
    "document_foreign_paperwork": documentForeignPaperwork,
    "status": status,
    "nb_job_posts": nbJobPosts,
    "nb_hired_freelancers": nbHiredFreelancers,
    "nb_completed_jobs": nbCompletedJobs,
    "is_favorite": isFavorite,
    "services": services == null
        ? []
        : List<dynamic>.from(services!.map((x) => x.toJson())),
    "packages": packages == null
        ? []
        : List<dynamic>.from(packages!.map((x) => x.toJson())),
    "job_posts": jobPosts == null
        ? []
        : List<dynamic>.from(jobPosts!.map((x) => x.toJson())),
  };
}
