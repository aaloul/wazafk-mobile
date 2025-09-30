import '../../model/ApiResponse.dart';
import '../../networking/services/notification/notification_service.dart';

class NotificationRepository {
  final _provider = NotificationService();

  Future<ApiResponse> getNotifications({Map<String, String>? filters}) async {
    return _provider.getNotifications(filters: filters);
  }

  Future<ApiResponse> markNotificationRead(String hashcode) async {
    return _provider.markNotificationRead(hashcode);
  }

  Future<ApiResponse> markAllNotificationsRead() async {
    return _provider.markAllNotificationsRead();
  }
}
