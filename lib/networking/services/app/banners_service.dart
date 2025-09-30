import 'package:wazafak_app/model/BannersResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class BannersService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<BannersResponse> getBanners(String type) async {
    final response = await _helper.get("${Endpoints.banners}?area=$type");
    return response;
  }
}
