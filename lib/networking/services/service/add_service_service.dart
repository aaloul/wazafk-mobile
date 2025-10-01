import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddServiceService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addService(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addService, data);
    return ApiResponse.fromJson(response);
  }
}
