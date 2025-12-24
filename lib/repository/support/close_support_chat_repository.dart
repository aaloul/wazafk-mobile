import '../../model/ApiResponse.dart';
import '../../networking/services/support/close_support_chat_service.dart';

class CloseSupportChatRepository {
  final _provider = CloseSupportChatService();

  Future<ApiResponse> createChat({
    required String hashcode,
  }) async {
    return _provider.closeSupportChat(hashcode: hashcode);
  }
}
