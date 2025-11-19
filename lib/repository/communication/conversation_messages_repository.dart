import 'package:wazafak_app/model/ConversationMessagesResponse.dart';
import '../../networking/services/communication/conversation_messages_service.dart';

class ConversationMessagesRepository {
  final _provider = ConversationMessagesService();

  Future<ConversationMessagesResponse> getConversationMessages({
    required String customerId,
    String page = '1',
  }) async {
    return _provider.getConversationMessages(
      customerId: customerId,
      page: page,
    );
  }
}
