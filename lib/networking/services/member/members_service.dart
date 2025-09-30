import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class MembersService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getMembers({Map<String, String>? filters}) async {
    String url = Endpoints.members;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }
}
