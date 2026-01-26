import 'package:wazafak_app/model/SearchSuggestionResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SearchSuggestionService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SearchSuggestionResponse> getSearchSuggestion({required String hint}) async {
    final response = await _helper.get('${Endpoints.suggestSearch}?query=$hint');
    return SearchSuggestionResponse.fromJson(response);
  }
}
