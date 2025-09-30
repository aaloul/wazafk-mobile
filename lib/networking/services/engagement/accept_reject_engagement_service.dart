import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AcceptRejectEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> acceptRejectEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'accept': accept};
    if (reason != null) body['reason'] = reason;
    final response = await _helper.post(Endpoints.acceptRejectEngagement, body);
    return response;
  }
}
