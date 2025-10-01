import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ActivityLogService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getActivityLog() async {
    final response = await _helper.get(Endpoints.activityLog);
    return ApiResponse.fromJson(response);
  }
}
