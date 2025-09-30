import '../../model/ApiResponse.dart';
import '../../networking/services/account/activity_log_service.dart';

class ActivityLogRepository {
  final _provider = ActivityLogService();

  Future<ApiResponse> getActivityLog() async {
    return _provider.getActivityLog();
  }
}
