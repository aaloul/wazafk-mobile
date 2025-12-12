import 'dart:io';

import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/account/face_match_service.dart';

class FaceMatchRepository {
  final _provider = FaceMatchService();

  Future<ApiResponse> faceMatch(File faceImage) async {
    return _provider.faceMatch(faceImage);
  }
}
