import '../../model/ApiResponse.dart';
import '../../networking/services/support/chat_categories_service.dart';

class ChatCategoriesRepository {
  final _provider = ChatCategoriesService();

  Future<ApiResponse> getChatCategories() async {
    return _provider.getChatCategories();
  }
}
