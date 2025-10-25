import '../../model/RatingCriteriaResponse.dart';
import '../../networking/services/rating/rating_criteria_service.dart';

class RatingCriteriaRepository {
  final _provider = RatingCriteriaService();

  Future<RatingCriteriaResponse> getRatingCriteria(
      {required String target}) async {
    return _provider.getRatingCriteria(target: target);
  }
}
