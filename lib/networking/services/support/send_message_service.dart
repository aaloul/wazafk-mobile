import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SendMessageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendMessage(
    String chatHashcode,
    String message, {
    String? attachment,
  }) async {
    final Map<String, dynamic> body = {
      'chat_hashcode': chatHashcode,
      'message': message,
    };
    if (attachment != null) body['attachment'] = attachment;
    final response = await _helper.post(Endpoints.sendMessage, body);
    return ApiResponse.fromJson(response);
  }
}
