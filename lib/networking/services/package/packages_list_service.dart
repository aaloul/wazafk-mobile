import 'package:wazafak_app/model/PackagesResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class PackagesListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<PackagesResponse> getPackages({Map<String, String>? filters}) async {
    String url = Endpoints.packages;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return PackagesResponse.fromJson(response);
  }
}
