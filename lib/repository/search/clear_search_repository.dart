import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/search/clear_search_service.dart';

class ClearSearchRepository {
  final _provider = ClearSearchService();

  Future<ApiResponse> clearSearch() async {
    return _provider.clearSearch({});
  }
}
