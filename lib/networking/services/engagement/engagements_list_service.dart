import 'package:wazafak_app/model/EngagementsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class EngagementsListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<EngagementsResponse> getEngagements(
      {Map<String, String>? filters}) async {
    String url = Endpoints.engagements;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return EngagementsResponse.fromJson(response);
  }
}
