// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? success;
  String? message;
  User? data;

  LoginResponse({this.success, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class User {
  String? hashcode;
  String? token;
  String? code;
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
  dynamic website;
  int? rating;
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

  User({
    this.hashcode,
    this.token,
    this.code,
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
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    hashcode: json["hashcode"],
    token: json["token"],
    code: json["code"],
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
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "token": token,
    "code": code,
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
  };
}
