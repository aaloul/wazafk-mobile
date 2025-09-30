import '../../model/ApiResponse.dart';
import '../../networking/services/service/service_detail_service.dart';

class ServiceDetailRepository {
  final _provider = ServiceDetailService();

  Future<ApiResponse> getService(String hashcode) async {
    return _provider.getService(hashcode);
  }
}
