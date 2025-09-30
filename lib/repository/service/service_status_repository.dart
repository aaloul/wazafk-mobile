import '../../model/ApiResponse.dart';
import '../../networking/services/service/service_status_service.dart';

class ServiceStatusRepository {
  final _provider = ServiceStatusService();

  Future<ApiResponse> updateServiceStatus(String hashcode, int status) async {
    return _provider.updateServiceStatus(hashcode, status);
  }
}
