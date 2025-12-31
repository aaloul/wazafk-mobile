import '../../model/SupportConversationsResponse.dart';
import '../../networking/services/support/support_conversations_service.dart';

class SupportConversationsRepository {
  final _provider = SupportConversationsService();

  Future<SupportConversationsResponse> getSupportConversations({
    Map<String, String>? filters,
  }) async {
    return _provider.getSupportConversations(filters: filters);
  }
}
