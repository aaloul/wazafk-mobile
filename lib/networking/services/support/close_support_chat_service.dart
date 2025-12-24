import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class CloseSupportChatService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> closeSupportChat({
    required String hashcode,
}) async {

    final Map<String, dynamic> body = {
      'hashcode': hashcode,
    };

    final response = await _helper.post(Endpoints.closeConversation, body);
    return ApiResponse.fromJson(response);
  }
}
