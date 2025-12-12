import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FaceMatchService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> faceMatch(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.faceMatch, data);
    return ApiResponse.fromJson(response);
  }
}
