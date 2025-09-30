import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class ServiceDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getService(String hashcode) async {
    final response = await _helper.get('service/service/$hashcode');
    return response;
  }
}
