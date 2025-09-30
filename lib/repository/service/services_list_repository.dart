import '../../model/ApiResponse.dart';
import '../../networking/services/service/services_list_service.dart';

class ServicesListRepository {
  final _provider = ServicesListService();

  Future<ApiResponse> getServices({Map<String, String>? filters}) async {
    return _provider.getServices(filters: filters);
  }
}
