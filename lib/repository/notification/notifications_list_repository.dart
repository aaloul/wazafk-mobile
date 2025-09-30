import '../../model/ApiResponse.dart';
import '../../networking/services/notification/notifications_list_service.dart';

class NotificationsListRepository {
  final _provider = NotificationsListService();

  Future<ApiResponse> getNotifications({Map<String, String>? filters}) async {
    return _provider.getNotifications(filters: filters);
  }
}
