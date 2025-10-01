import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class LoginService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> login(String mobile, String password) async {
    final Map<String, dynamic> body = {'mobile': mobile, 'password': password};
    final response = await _helper.post(Endpoints.login, body);
    return ApiResponse.fromJson(response);
  }
}
