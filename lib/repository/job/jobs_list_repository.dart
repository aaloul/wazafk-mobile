import 'package:wazafak_app/model/JobsResponse.dart';

import '../../networking/services/job/jobs_list_service.dart';

class JobsListRepository {
  final _provider = JobsListService();

  Future<JobsResponse> getJobs({Map<String, String>? filters}) async {
    return _provider.getJobs(filters: filters);
  }
}
