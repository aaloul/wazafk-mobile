import 'package:wazafak_app/model/EmployerHomeResponse.dart';

import '../../networking/services/search/employer_search_service.dart';

class EmployerSearchRepository {
  final _provider = EmployerSearchService();

  Future<EmployerHomeResponse> employerSearch({
    Map<String, String>? filters,
  }) async {
    return _provider.employerSearch(filters: filters);
  }
}
