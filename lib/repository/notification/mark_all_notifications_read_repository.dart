import '../../model/ApiResponse.dart';
import '../../networking/services/notification/mark_all_notifications_read_service.dart';

class MarkAllNotificationsReadRepository {
  final _provider = MarkAllNotificationsReadService();

  Future<ApiResponse> markAllNotificationsRead() async {
    return _provider.markAllNotificationsRead();
  }
}
