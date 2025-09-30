import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class InterestCategoriesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getInterestCategories({String? interest}) async {
    String url = Endpoints.interestCategories;
    if (interest != null && interest.isNotEmpty) {
      url += '?interest=$interest';
    }
    final response = await _helper.get(url);
    return response;
  }
}
