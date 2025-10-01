import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SubmitEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> submitEngagement(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.submitEngagement, data);
    return ApiResponse.fromJson(response);
  }
}
