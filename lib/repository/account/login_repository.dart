import '../../model/ApiResponse.dart';
import '../../networking/services/account/login_service.dart';

class LoginRepository {
  final _provider = LoginService();

  Future<ApiResponse> login(String mobile, String password) async {
    return _provider.login(mobile, password);
  }
}
