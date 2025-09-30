import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddFavoriteJobService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addFavoriteJob(String jobHashcode) async {
    final Map<String, dynamic> body = {'job_hashcode': jobHashcode};
    final response = await _helper.post(Endpoints.addFavoriteJob, body);
    return response;
  }
}
