import '../../model/ApiResponse.dart';
import '../../networking/services/account/logout_service.dart';

class LogoutRepository {
  final _provider = LogoutService();

  Future<ApiResponse> logout() async {
    return _provider.logout();
  }
}
