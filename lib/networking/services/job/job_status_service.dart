import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class JobStatusService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> updateJobStatus(String hashcode, int status) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'status': status};
    final response = await _helper.post(Endpoints.jobStatus, body);
    return ApiResponse.fromJson(response);
  }
}
