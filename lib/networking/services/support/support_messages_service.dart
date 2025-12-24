import 'package:wazafak_app/model/SupportConversationMessagesResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SupportMessagesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SupportConversationMessagesResponse> getSupportConversationMessages({
    required String conversation
}) async {
    final response = await _helper.get('${Endpoints.getSupportConversationMessages}?conversation=$conversation');
    return SupportConversationMessagesResponse.fromJson(response);
  }
}
