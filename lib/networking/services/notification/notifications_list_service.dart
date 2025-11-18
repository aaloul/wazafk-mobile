import '../../../model/ApiResponse.dart';
import '../../../model/NotificationsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class NotificationsListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<NotificationsResponse> getNotifications(
      {Map<String, String>? filters}) async {
    String url = Endpoints.notifications;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return NotificationsResponse.fromJson(response);
  }

  Future<ApiResponse> markNotificationAsRead(String hashcode) async {
    final response = await _helper.post(
      Endpoints.markNotificationRead,
      {'hashcode': hashcode,
        'read': "1",
      },
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> markAllNotificationsAsRead() async {
    final response = await _helper.post(
      Endpoints.markAllNotificationsRead,
      {},
    );
    return ApiResponse.fromJson(response);
  }
}
