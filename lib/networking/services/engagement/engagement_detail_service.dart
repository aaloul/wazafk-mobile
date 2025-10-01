import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class EngagementDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getEngagement(String hashcode) async {
    final response = await _helper.get('engagement/engagement/$hashcode');
    return ApiResponse.fromJson(response);
  }
}
