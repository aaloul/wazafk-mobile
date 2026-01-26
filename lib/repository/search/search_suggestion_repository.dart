import 'package:wazafak_app/model/SearchSuggestionResponse.dart';

import '../../networking/services/search/search_suggestion_service.dart';

class SearchSuggestionRepository {
  final _provider = SearchSuggestionService();

  Future<SearchSuggestionResponse> getSearchSuggestion({required String hint}) async {
    return _provider.getSearchSuggestion(hint: hint);
  }
}
