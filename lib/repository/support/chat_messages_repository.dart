import '../../model/ApiResponse.dart';
import '../../networking/services/support/chat_messages_service.dart';

class ChatMessagesRepository {
  final _provider = ChatMessagesService();

  Future<ApiResponse> getChatMessages(String chatHashcode) async {
    return _provider.getChatMessages(chatHashcode);
  }
}
