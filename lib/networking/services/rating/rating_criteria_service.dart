import '../../../model/RatingCriteriaResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RatingCriteriaService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<RatingCriteriaResponse> getRatingCriteria(
      {required String target}) async {
    final response = await _helper.get(
        '${Endpoints.ratingCriteria}?target=$target');
    return RatingCriteriaResponse.fromJson(response);
  }
}
