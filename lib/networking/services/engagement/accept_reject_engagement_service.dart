import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AcceptRejectEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> acceptRejectEngagement({required String hashcode,
    required bool accept}) async {
    final Map<String, dynamic> body = {
      'hashcode': hashcode,
      'accept_reject': accept ? 'A' : 'R'
    };
    final response = await _helper.post(Endpoints.acceptRejectEngagement, body);
    return ApiResponse.fromJson(response);
  }
}
