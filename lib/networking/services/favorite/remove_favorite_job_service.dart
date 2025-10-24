import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RemoveFavoriteJobService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> removeFavoriteJob(String jobHashcode) async {
    final Map<String, dynamic> body = {'favorite_job': jobHashcode};
    final response = await _helper.post(Endpoints.removeFavoriteJob, body);
    return ApiResponse.fromJson(response);
  }
}
