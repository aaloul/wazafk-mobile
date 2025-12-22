import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, Get.context != null ? Resources
      .of(Get.context!)
      .strings
      .errorDuringCommunication("") : "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message])
      : super(message, Get.context != null ? Resources
      .of(Get.context!)
      .strings
      .invalidRequest("") : "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message])
      : super(message, Get.context != null ? Resources
      .of(Get.context!)
      .strings
      .unauthorised("") : "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, Get.context != null ? Resources
      .of(Get.context!)
      .strings
      .invalidInput("") : "Invalid Input: ");
}
