import 'package:wazafak_app/model/ConversationMessagesResponse.dart';

import '../../../model/ContactsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ConversationMessagesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ConversationMessagesResponse> getConversationMessages({
    required String customerId,
    String page = '1',
  }) async {
    String url = '${Endpoints.messages}?member=$customerId&page=$page';

    final response = await _helper.get(url);
    return ConversationMessagesResponse.fromJson(response);
  }
}
