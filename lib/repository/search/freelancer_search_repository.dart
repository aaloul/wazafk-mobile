import 'package:wazafak_app/model/FreelancerHomeResponse.dart';

import '../../networking/services/search/freelancer_search_service.dart';

class FreelancerSearchRepository {
  final _provider = FreelancerSearchService();

  Future<FreelancerHomeResponse> freelancerSearch({
    Map<String, String>? filters,
  }) async {
    return _provider.freelancerSearch(filters: filters);
  }
}
