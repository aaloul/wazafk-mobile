import '../../model/ApiResponse.dart';
import '../../networking/services/job/jobs_list_service.dart';

class JobsListRepository {
  final _provider = JobsListService();

  Future<ApiResponse> getJobs({Map<String, String>? filters}) async {
    return _provider.getJobs(filters: filters);
  }
}
