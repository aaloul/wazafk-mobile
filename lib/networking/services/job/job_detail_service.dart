import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class JobDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getJob(String hashcode) async {
    final response = await _helper.get('job/job/$hashcode');
    return response;
  }
}
