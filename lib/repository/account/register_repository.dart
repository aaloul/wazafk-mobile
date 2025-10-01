import '../../model/LoginResponse.dart';
import '../../networking/services/account/register_service.dart';

class RegisterRepository {
  final _provider = RegisterService();

  Future<LoginResponse> register(Map<String, dynamic> data) async {
    return _provider.register(data);
  }
}
