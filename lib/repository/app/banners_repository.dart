import 'package:wazafak_app/model/BannersResponse.dart';

import '../../networking/services/app/banners_service.dart';

class BannersRepository {
  final _provider = BannersService();

  Future<BannersResponse> getBanners(String type) async {
    return _provider.getBanners(type);
  }
}
