import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class MarkAllNotificationsReadService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> markAllNotificationsRead() async {
    final response = await _helper.post(Endpoints.markAllNotificationsRead, {});
    return ApiResponse.fromJson(response);
  }
}
