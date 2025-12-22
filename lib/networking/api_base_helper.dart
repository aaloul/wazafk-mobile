import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as httpPackage;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../utils/Prefs.dart';
import '../utils/utils.dart';
import 'Endpoints.dart';
import 'app_exceptions.dart';

class ApiBaseHelper {
  HttpWithMiddleware http = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );

  Future<dynamic> getPublic(String url) async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getRequestHeader(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnection,
      );
    }
    printWrapped(responseJson.toString());

    return responseJson;
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(Prefs.getEnvUrl + url),
        headers: getRequestHeader(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnection,
      );
    }
    printWrapped(responseJson.toString());

    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(Prefs.getEnvUrl + url),
        body: jsonEncode(body),
        headers: getRequestHeader(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnection,
      );
    }
    printWrapped(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> patch(String url, dynamic body) async {
    var responseJson;
    try {
      final response = await http.patch(
        Uri.parse(Prefs.getEnvUrl + url),
        body: jsonEncode(body),
        headers: getRequestHeader(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnection,
      );
    }
    printWrapped(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(Prefs.getEnvUrl + url),
        body: jsonEncode(body),
        headers: getRequestHeader(),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnection,
      );
    }
    printWrapped(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var apiResponse;
    try {
      final response = await http.delete(
        Uri.parse(Prefs.getEnvUrl + url),
        headers: getRequestHeader(),
      );
      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnectionLowercase,
      );
    }
    return apiResponse;
  }

  Future<dynamic> postMultipart(
    String url,
    Map<String, String> fields,
      List<httpPackage.MultipartFile> files,
  ) async {
    var responseJson;
    try {
      var request = httpPackage.MultipartRequest(
          'POST', Uri.parse(Prefs.getEnvUrl + url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (Prefs.getLoggedIn)
          Params.authorization: 'Bearer ${Prefs.getToken}'.toString(),
        Params.language: Prefs.getLanguage.toString(),
      });

      // Add fields
      request.fields.addAll(fields);

      // Add files
      request.files.addAll(files);

      var streamedResponse = await request.send();
      var response = await httpPackage.Response.fromStream(streamedResponse);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .noInternetConnection,
      );
    }
    printWrapped(responseJson.toString());
    return responseJson;
  }
}

dynamic _returnResponse(httpPackage.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 201:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 404:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 422:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
        Resources
            .of(Get.context!)
            .strings
            .errorOccuredCommunication(response.statusCode.toString()),
      );
  }
}

Map<String, String> getRequestHeader() {
  var map = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (Prefs.getLoggedIn)
      Params.authorization: 'Bearer ${Prefs.getToken}'.toString(),
    Params.language: Prefs.getLanguage.toString(),
  };
  return map;
}
