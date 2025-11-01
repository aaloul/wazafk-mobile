import '../../../model/FreelancerHomeResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FreelancerSearchService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FreelancerHomeResponse> freelancerSearch({
    Map<String, String>? filters,
  }) async {
    String url = Endpoints.freelancerSearch;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return FreelancerHomeResponse.fromJson(response);
  }
}
