import '../../model/PackagesResponse.dart';
import '../../networking/services/package/packages_list_service.dart';

class PackagesListRepository {
  final _provider = PackagesListService();

  Future<PackagesResponse> getPackages({Map<String, String>? filters}) async {
    return _provider.getPackages(filters: filters);
  }
}
