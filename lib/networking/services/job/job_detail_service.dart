import '../../../model/JobsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class JobDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<JobsResponse> getJob(String hashcode) async {
    final response = await _helper.get('${Endpoints.jobs}?hashcode=$hashcode');
    return JobsResponse.fromJson(response);
  }
}
