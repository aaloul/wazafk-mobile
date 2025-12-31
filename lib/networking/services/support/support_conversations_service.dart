import 'package:wazafak_app/model/SupportConversationsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SupportConversationsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SupportConversationsResponse> getSupportConversations({Map<String, String>? filters}) async {
    String url = Endpoints.getSupportConversations;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return SupportConversationsResponse.fromJson(response);
  }
}
