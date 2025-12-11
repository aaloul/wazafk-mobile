import '../../model/JobsResponse.dart';
import '../../networking/services/job/job_detail_service.dart';

class JobDetailRepository {
  final _provider = JobDetailService();

  Future<JobsResponse> getJob(String hashcode) async {
    return _provider.getJob(hashcode);
  }
}
