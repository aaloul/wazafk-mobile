import '../../model/ApiResponse.dart';
import '../../networking/services/notification/mark_notification_read_service.dart';

class MarkNotificationReadRepository {
  final _provider = MarkNotificationReadService();

  Future<ApiResponse> markNotificationRead(String hashcode) async {
    return _provider.markNotificationRead(hashcode);
  }
}
