import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class JobService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addJob(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addJob, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> saveJob(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveJob, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> updateJobStatus(String hashcode, int status) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'status': status};
    final response = await _helper.post(Endpoints.jobStatus, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getJobs({Map<String, String>? filters}) async {
    String url = Endpoints.jobs;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getJob(String hashcode) async {
    final response = await _helper.get('job/job/$hashcode');
    return ApiResponse.fromJson(response);
  }
}
