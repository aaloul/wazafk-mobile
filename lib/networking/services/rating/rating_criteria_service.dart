import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class RatingCriteriaService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getRatingCriteria() async {
    final response = await _helper.get(Endpoints.ratingCriteria);
    return response;
  }
}
