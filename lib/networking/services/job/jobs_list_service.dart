import '../../../model/JobsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class JobsListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<JobsResponse> getJobs({Map<String, String>? filters}) async {
    String url = Endpoints.jobs;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return JobsResponse.fromJson(response);
  }
}
