import 'package:wazafak_app/model/JobApplicantsResponse.dart';

import '../../networking/services/job/job_applicants_service.dart';

class JobApplicantsRepository {
  final _provider = JobApplicantsService();

  Future<JobApplicantsResponse> getJobApplicants({
    Map<String, String>? filters,
  }) async {
    return _provider.getJobApplicants(filters: filters);
  }
}
