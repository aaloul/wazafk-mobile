// Response model for `member/checkEmailExists`.

class CheckEmailResponse {
  bool? success;
  String? message;
  CheckEmailData? data;

  CheckEmailResponse({this.success, this.message, this.data});

  factory CheckEmailResponse.fromJson(Map<String, dynamic> json) =>
      CheckEmailResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : CheckEmailData.fromJson(json["data"]),
      );
}

class CheckEmailData {
  bool? exists;

  CheckEmailData({this.exists});

  factory CheckEmailData.fromJson(Map<String, dynamic> json) =>
      CheckEmailData(exists: json["exists"]);
}
