import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SendSupportMessageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendMessage(
    String chatHashcode,
    String message, {
    String? attachment,
  }) async {
    final Map<String, dynamic> body = {
      'conversation': chatHashcode,
      'message': message,
    };
    final response = await _helper.post(Endpoints.sendSupportMessage, body);
    return ApiResponse.fromJson(response);
  }
}
