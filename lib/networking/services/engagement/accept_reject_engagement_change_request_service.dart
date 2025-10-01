import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AcceptRejectEngagementChangeRequestService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> acceptRejectEngagementChangeRequest(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'accept': accept};
    if (reason != null) body['reason'] = reason;
    final response = await _helper.post(
      Endpoints.acceptRejectEngagementChangeRequest,
      body,
    );
    return ApiResponse.fromJson(response);
  }
}
