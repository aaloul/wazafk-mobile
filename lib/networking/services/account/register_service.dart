import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class RegisterService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> register(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.register, data);
    return response;
  }
}
