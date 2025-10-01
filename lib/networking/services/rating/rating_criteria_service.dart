import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RatingCriteriaService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getRatingCriteria() async {
    final response = await _helper.get(Endpoints.ratingCriteria);
    return ApiResponse.fromJson(response);
  }
}
