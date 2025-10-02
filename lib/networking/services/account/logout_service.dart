import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class LogoutService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> logout() async {
    final response = await _helper.get(Endpoints.logout);
    return ApiResponse.fromJson(response);
  }
}
