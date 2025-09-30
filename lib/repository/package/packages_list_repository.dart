import '../../model/ApiResponse.dart';
import '../../networking/services/package/packages_list_service.dart';

class PackagesListRepository {
  final _provider = PackagesListService();

  Future<ApiResponse> getPackages({Map<String, String>? filters}) async {
    return _provider.getPackages(filters: filters);
  }
}
