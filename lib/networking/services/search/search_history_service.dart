import 'package:wazafak_app/model/SearchHistoryResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SearchHistoryService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SearchHistoryResponse> getSearchHistory() async {
    final response = await _helper.get(Endpoints.searchHistory);
    return SearchHistoryResponse.fromJson(response);
  }
}
