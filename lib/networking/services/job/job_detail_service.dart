import '../../../model/JobsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class JobDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<JobsResponse> getJob(String hashcode, {String? memberHashcode}) async {
    String url = '${Endpoints.jobs}?hashcode=$hashcode';
    if (memberHashcode != null && memberHashcode.isNotEmpty) {
      url += '&member=$memberHashcode';
    }
    final response = await _helper.get(url);
    return JobsResponse.fromJson(response);
  }
}
