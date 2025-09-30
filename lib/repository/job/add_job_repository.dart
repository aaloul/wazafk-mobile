import '../../model/ApiResponse.dart';
import '../../networking/services/job/add_job_service.dart';

class AddJobRepository {
  final _provider = AddJobService();

  Future<ApiResponse> addJob(Map<String, dynamic> data) async {
    return _provider.addJob(data);
  }
}
