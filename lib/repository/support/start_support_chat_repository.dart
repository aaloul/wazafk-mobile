import '../../model/ApiResponse.dart';
import '../../networking/services/support/start_support_chat_service.dart';

class StartSupportChatRepository {
  final _provider = StartSupportChatService();

  Future<ApiResponse> createChat({
    required String category,
    required String subject,
  }) async {
    return _provider.startSupportChat(category: category, subject: subject);
  }
}
