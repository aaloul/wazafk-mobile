import '../../model/ApiResponse.dart';
import '../../networking/services/job/job_service.dart';

class JobRepository {
  final _provider = JobService();

  Future<ApiResponse> addJob(Map<String, dynamic> data) async {
    return _provider.addJob(data);
  }

  Future<ApiResponse> saveJob(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveJob(hashcode, data);
  }

  Future<ApiResponse> updateJobStatus(String hashcode, int status) async {
    return _provider.updateJobStatus(hashcode, status);
  }

  Future<ApiResponse> getJobs({Map<String, String>? filters}) async {
    return _provider.getJobs(filters: filters);
  }

  Future<ApiResponse> getJob(String hashcode) async {
    return _provider.getJob(hashcode);
  }
}
