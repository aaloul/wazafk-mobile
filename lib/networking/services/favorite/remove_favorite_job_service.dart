import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class RemoveFavoriteJobService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> removeFavoriteJob(String jobHashcode) async {
    final Map<String, dynamic> body = {'job_hashcode': jobHashcode};
    final response = await _helper.post(Endpoints.removeFavoriteJob, body);
    return response;
  }
}
