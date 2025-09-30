import '../../model/ApiResponse.dart';
import '../../networking/services/support/create_chat_service.dart';

class CreateChatRepository {
  final _provider = CreateChatService();

  Future<ApiResponse> createChat(Map<String, dynamic> data) async {
    return _provider.createChat(data);
  }
}
