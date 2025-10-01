import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RegisterService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> register(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.register, data);
    return ApiResponse.fromJson(response);
  }
}
