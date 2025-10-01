import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class EngagementsListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getEngagements({Map<String, String>? filters}) async {
    String url = Endpoints.engagements;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return ApiResponse.fromJson(response);
  }
}
