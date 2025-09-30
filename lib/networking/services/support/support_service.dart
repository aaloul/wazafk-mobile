import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SupportService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getChatCategories() async {
    final response = await _helper.get(Endpoints.chatCategories);
    return response;
  }

  Future<ApiResponse> createChat(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.createChat, data);
    return response;
  }

  Future<ApiResponse> getChats() async {
    final response = await _helper.get(Endpoints.chats);
    return response;
  }

  Future<ApiResponse> getChat(String hashcode) async {
    final response = await _helper.get('support/chat/$hashcode');
    return response;
  }

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
    return response;
  }

  Future<ApiResponse> getChatMessages(String chatHashcode) async {
    final response = await _helper.get('support/chatMessages/$chatHashcode');
    return response;
  }
}
