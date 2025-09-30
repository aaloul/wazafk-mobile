import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class SaveServiceService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> saveService(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveService, data);
    return response;
  }
}
