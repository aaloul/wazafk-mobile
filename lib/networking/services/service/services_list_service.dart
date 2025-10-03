import '../../../model/ServicesResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ServicesListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ServicesResponse> getServices({Map<String, String>? filters}) async {
    String url = Endpoints.services;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return ServicesResponse.fromJson(response);
  }
}
