import '../../../model/LoginResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class LoginService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginResponse> login(String mobile, String password) async {
    final Map<String, dynamic> body = {'mobile': mobile, 'password': password};
    final response = await _helper.post(Endpoints.login, body);
    return LoginResponse.fromJson(response);
  }
}
