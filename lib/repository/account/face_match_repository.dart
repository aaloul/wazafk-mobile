import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/account/face_match_service.dart';

class FaceMatchRepository {
  final _provider = FaceMatchService();

  Future<ApiResponse> faceMatch(Map<String, dynamic> data) async {
    return _provider.faceMatch(data);
  }
}
