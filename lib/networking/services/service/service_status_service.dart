import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ServiceStatusService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> updateServiceStatus(String hashcode, int status) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'status': status};
    final response = await _helper.post(Endpoints.serviceStatus, body);
    return ApiResponse.fromJson(response);
  }
}
