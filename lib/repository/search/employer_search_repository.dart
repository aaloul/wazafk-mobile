import 'package:wazafak_app/model/EmployerHomeResponse.dart';

import '../../model/SearchResponse.dart';
import '../../networking/services/search/employer_search_service.dart';

class EmployerSearchRepository {
  final _provider = EmployerSearchService();

  Future<SearchResponse> employerSearch({
    Map<String, String>? filters,
  }) async {
    return _provider.employerSearch(filters: filters);
  }
}
