import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class StartSupportChatService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> startSupportChat({
    required String category,
    required String subject,
}) async {

    final Map<String, dynamic> body = {
      'category': category,
      'subject': subject,
    };

    final response = await _helper.post(Endpoints.startConversation, body);
    return ApiResponse.fromJson(response);
  }
}
