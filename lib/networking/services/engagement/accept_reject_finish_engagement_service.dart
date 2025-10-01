import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AcceptRejectFinishEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> acceptRejectFinishEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'accept': accept};
    if (reason != null) body['reason'] = reason;
    final response = await _helper.post(
      Endpoints.acceptRejectFinishEngagement,
      body,
    );
    return ApiResponse.fromJson(response);
  }
}
