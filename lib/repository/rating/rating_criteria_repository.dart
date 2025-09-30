import '../../networking/services/rating/rating_criteria_service.dart';
import '../../model/ApiResponse.dart';

class RatingCriteriaRepository {
  final _provider = RatingCriteriaService();

  Future<ApiResponse> getRatingCriteria() async {
    return _provider.getRatingCriteria();
  }
}
