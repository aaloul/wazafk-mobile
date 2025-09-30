import '../../networking/services/service/save_service_service.dart';
import '../../model/ApiResponse.dart';

class SaveServiceRepository {
  final _provider = SaveServiceService();

  Future<ApiResponse> saveService(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveService(hashcode, data);
  }
}
