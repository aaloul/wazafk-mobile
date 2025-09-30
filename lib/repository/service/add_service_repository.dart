import '../../model/ApiResponse.dart';
import '../../networking/services/service/add_service_service.dart';

class AddServiceRepository {
  final _provider = AddServiceService();

  Future<ApiResponse> addService(Map<String, dynamic> data) async {
    return _provider.addService(data);
  }
}
