import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SendMessageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendMessage({
    required String member,
    required String message,
  }) async {
    final Map<String, dynamic> body = {'member': member, 'message': message};
    final response = await _helper.post(Endpoints.sendMessage, body);
    return ApiResponse.fromJson(response);
  }
}
