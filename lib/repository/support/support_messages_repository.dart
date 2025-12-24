import '../../model/SupportConversationMessagesResponse.dart';
import '../../networking/services/support/support_messages_service.dart';

class SupportMessagesRepository {
  final _provider = SupportMessagesService();

  Future<SupportConversationMessagesResponse> getSupportConversationMessages({
    required String conversation
}) async {
    return _provider.getSupportConversationMessages(conversation: conversation);
  }
}
