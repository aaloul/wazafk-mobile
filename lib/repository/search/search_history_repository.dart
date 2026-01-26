import 'package:wazafak_app/model/SearchHistoryResponse.dart';

import '../../networking/services/search/search_history_service.dart';

class SearchHistoryRepository {
  final _provider = SearchHistoryService();

  Future<SearchHistoryResponse> getSearchHistory() async {
    return _provider.getSearchHistory();
  }
}
