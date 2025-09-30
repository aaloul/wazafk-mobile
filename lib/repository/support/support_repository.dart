import '../../model/ApiResponse.dart';
import '../../networking/services/support/support_service.dart';

class SupportRepository {
  final _provider = SupportService();

  Future<ApiResponse> getChatCategories() async {
    return _provider.getChatCategories();
  }

  Future<ApiResponse> createChat(Map<String, dynamic> data) async {
    return _provider.createChat(data);
  }

  Future<ApiResponse> getChats() async {
    return _provider.getChats();
  }

  Future<ApiResponse> getChat(String hashcode) async {
    return _provider.getChat(hashcode);
  }

  Future<ApiResponse> sendMessage(
    String chatHashcode,
    String message, {
    String? attachment,
  }) async {
    return _provider.sendMessage(chatHashcode, message, attachment: attachment);
  }

  Future<ApiResponse> getChatMessages(String chatHashcode) async {
    return _provider.getChatMessages(chatHashcode);
  }
}
