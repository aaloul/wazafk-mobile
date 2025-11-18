import '../../model/ApiResponse.dart';
import '../../model/NotificationsResponse.dart';
import '../../networking/services/notification/notifications_list_service.dart';

class NotificationsListRepository {
  final _provider = NotificationsListService();

  Future<NotificationsResponse> getNotifications(
      {Map<String, String>? filters}) async {
    return _provider.getNotifications(filters: filters);
  }

  Future<ApiResponse> markNotificationAsRead(String hashcode) async {
    return _provider.markNotificationAsRead(hashcode);
  }

  Future<ApiResponse> markAllNotificationsAsRead() async {
    return _provider.markAllNotificationsAsRead();
  }
}
