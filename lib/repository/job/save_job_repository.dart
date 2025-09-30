import '../../networking/services/job/save_job_service.dart';
import '../../model/ApiResponse.dart';

class SaveJobRepository {
  final _provider = SaveJobService();

  Future<ApiResponse> saveJob(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveJob(hashcode, data);
  }
}
