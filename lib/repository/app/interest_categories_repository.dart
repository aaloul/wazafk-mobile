import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/app/interest_categories_service.dart';

class InterestCategoriesRepository {
  final _provider = InterestCategoriesService();

  Future<ApiResponse> getInterestCategories({String? interest}) async {
    return _provider.getInterestCategories(interest: interest);
  }
}
