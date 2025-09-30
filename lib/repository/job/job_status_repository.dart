import '../../model/ApiResponse.dart';
import '../../networking/services/job/job_status_service.dart';

class JobStatusRepository {
  final _provider = JobStatusService();

  Future<ApiResponse> updateJobStatus(String hashcode, int status) async {
    return _provider.updateJobStatus(hashcode, status);
  }
}
