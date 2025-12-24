import 'package:wazafak_app/model/SupportStartConversationResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class LastSupportConversationService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SupportStartConversationResponse> getLastSupportConversation() async {
    final response = await _helper.get(Endpoints.lastConversation);
    return SupportStartConversationResponse.fromJson(response);
  }
}
