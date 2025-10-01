import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FavoriteJobsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getFavoriteJobs() async {
    final response = await _helper.get(Endpoints.favoriteJobs);
    return ApiResponse.fromJson(response);
  }
}
