import 'dart:io';

import 'package:http/http.dart';
import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FaceMatchService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> faceMatch(File faceImage) async {
    // Create multipart file from the image
    var multipartFile = await MultipartFile.fromPath(
      'face',
      faceImage.path,
    );

    // Send as multipart request
    final response = await _helper.postMultipart(
      Endpoints.faceMatch,
      {},
      [multipartFile],
    );

    return ApiResponse.fromJson(response);
  }
}
