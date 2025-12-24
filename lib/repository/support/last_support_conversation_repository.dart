import '../../model/SupportStartConversationResponse.dart';
import '../../networking/services/support/last_support_conversation_service.dart';

class LastSupportConversationRepository {
  final _provider = LastSupportConversationService();

  Future<SupportStartConversationResponse> getLastSupportConversation() async {
    return _provider.getLastSupportConversation();
  }
}
