import 'package:wazafak_app/model/EngagementsResponse.dart';

import '../../api_base_helper.dart';

class EngagementDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<EngagementsResponse> getEngagement(String hashcode) async {
    final response = await _helper.get(
        'engagement/engagements?hashcode=$hashcode');
    return EngagementsResponse.fromJson(response);
  }
}
