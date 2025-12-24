import '../../model/ServicesResponse.dart';
import '../../networking/services/service/service_detail_service.dart';

class ServiceDetailRepository {
  final _provider = ServiceDetailService();

  Future<ServicesResponse> getService(String hashcode) async {
    return _provider.getService(hashcode);
  }
}
