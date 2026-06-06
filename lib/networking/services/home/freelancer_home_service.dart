import '../../../model/FreelancerHomeResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FreelancerHomeService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FreelancerHomeResponse> getFreelancerHome({
    Map<String, String>? filters,
  }) async {
    String url = Endpoints.freelancerHome;
    if (filters != null && filters.isNotEmpty) {
      final params =
          filters.entries.map((e) => '${e.key}=${e.value}').join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return FreelancerHomeResponse.fromJson(response);
  }
}
