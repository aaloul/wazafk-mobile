import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class ScheduleTasksService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addScheduleTask(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addScheduleTask, data);
    return response;
  }

  Future<ApiResponse> saveScheduleTask(String hashcode,
      Map<String, dynamic> data) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveScheduleTask, data);
    return response;
  }

  Future<ApiResponse> deleteScheduleTask(String hashcode) async {
    final response = await _helper.delete(
        "${Endpoints.deleteScheduleTask}/$hashcode");
    return response;
  }

  Future<ApiResponse> getScheduleTasks() async {
    final response = await _helper.get(Endpoints.scheduleTasks);
    return response;
  }
}