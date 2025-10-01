import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class ChatMessagesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getChatMessages(String chatHashcode) async {
    final response = await _helper.get('support/chatMessages/$chatHashcode');
    return ApiResponse.fromJson(response);
  }
}
