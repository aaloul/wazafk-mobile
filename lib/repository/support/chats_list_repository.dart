import '../../model/ApiResponse.dart';
import '../../networking/services/support/chats_list_service.dart';

class ChatsListRepository {
  final _provider = ChatsListService();

  Future<ApiResponse> getChats() async {
    return _provider.getChats();
  }
}
