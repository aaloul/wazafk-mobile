import '../../../model/EmployerHomeResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class EmployerSearchService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<EmployerHomeResponse> employerSearch({
    Map<String, String>? filters,
  }) async {
    String url = Endpoints.employerSearch;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return EmployerHomeResponse.fromJson(response);
  }
}
