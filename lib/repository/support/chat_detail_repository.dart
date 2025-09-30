import '../../model/ApiResponse.dart';
import '../../networking/services/support/chat_detail_service.dart';

class ChatDetailRepository {
  final _provider = ChatDetailService();

  Future<ApiResponse> getChat(String hashcode) async {
    return _provider.getChat(hashcode);
  }
}
