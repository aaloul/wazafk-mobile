import '../../model/ServicesResponse.dart';
import '../../networking/services/service/services_list_service.dart';

class ServicesListRepository {
  final _provider = ServicesListService();

  Future<ServicesResponse> getServices({Map<String, String>? filters}) async {
    return _provider.getServices(filters: filters);
  }
}
