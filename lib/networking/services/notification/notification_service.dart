import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class NotificationService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getNotifications({Map<String, String>? filters}) async {
    String url = Endpoints.notifications;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }

  Future<ApiResponse> markNotificationRead(String hashcode) async {
    final Map<String, dynamic> body = {'hashcode': hashcode};
    final response = await _helper.post(Endpoints.markNotificationRead, body);
    return response;
  }

  Future<ApiResponse> markAllNotificationsRead() async {
    final response = await _helper.post(Endpoints.markAllNotificationsRead, {});
    return response;
  }
}
