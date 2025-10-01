import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ScheduleTasksService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addScheduleTask(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addScheduleTask, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> saveScheduleTask(String hashcode,
      Map<String, dynamic> data) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveScheduleTask, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> deleteScheduleTask(String hashcode) async {
    final response = await _helper.delete(
        "${Endpoints.deleteScheduleTask}/$hashcode");
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getScheduleTasks() async {
    final response = await _helper.get(Endpoints.scheduleTasks);
    return ApiResponse.fromJson(response);
  }
}