import '../../model/ApiResponse.dart';
import '../../model/scheduleTasksResponse.dart';
import '../../networking/services/member/schedule_tasks_service.dart';

class ScheduleTasksRepository {
  final _provider = ScheduleTasksService();

  Future<ApiResponse> addScheduleTask(Map<String, dynamic> data) async {
    return _provider.addScheduleTask(data);
  }

  Future<ApiResponse> saveScheduleTask(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveScheduleTask(hashcode, data);
  }

  Future<ApiResponse> deleteScheduleTask(String hashcode) async {
    return _provider.deleteScheduleTask(hashcode);
  }

  Future<ScheduleTasksResponse> getScheduleTasks() async {
    return _provider.getScheduleTasks();
  }
}
