import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SubmitEngagementChangeRequestService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> submitEngagementChangeRequest(
    String hashcode,
    Map<String, dynamic> changes,
  ) async {
    changes['hashcode'] = hashcode;
    final response = await _helper.post(
      Endpoints.submitEngagementChangeRequest,
      changes,
    );
    return ApiResponse.fromJson(response);
  }
}
