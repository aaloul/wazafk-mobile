import '../../model/ApiResponse.dart';
import '../../networking/services/service/service_service.dart';

class ServiceRepository {
  final _provider = ServiceService();

  Future<ApiResponse> addService(Map<String, dynamic> data) async {
    return _provider.addService(data);
  }

  Future<ApiResponse> saveService(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveService(hashcode, data);
  }

  Future<ApiResponse> updateServiceStatus(String hashcode, int status) async {
    return _provider.updateServiceStatus(hashcode, status);
  }

  Future<ApiResponse> getServices({Map<String, String>? filters}) async {
    return _provider.getServices(filters: filters);
  }

  Future<ApiResponse> getService(String hashcode) async {
    return _provider.getService(hashcode);
  }
}
