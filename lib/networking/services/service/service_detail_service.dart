import '../../../model/ServicesResponse.dart';
import '../../api_base_helper.dart';

class ServiceDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ServicesResponse> getService(String hashcode) async {
    final response = await _helper.get('service/services?hashcode=$hashcode');
    return ServicesResponse.fromJson(response);
  }
}
