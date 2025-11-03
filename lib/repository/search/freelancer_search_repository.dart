import 'package:wazafak_app/model/FreelancerHomeResponse.dart';

import '../../model/SearchResponse.dart';
import '../../networking/services/search/freelancer_search_service.dart';

class FreelancerSearchRepository {
  final _provider = FreelancerSearchService();

  Future<SearchResponse> freelancerSearch({
    Map<String, String>? filters,
  }) async {
    return _provider.freelancerSearch(filters: filters);
  }
}
