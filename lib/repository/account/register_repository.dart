import '../../model/ApiResponse.dart';
import '../../networking/services/account/register_service.dart';
import '../../model/ApiResponse.dart';

class RegisterRepository {
  final _provider = RegisterService();

  Future<ApiResponse> register(Map<String, dynamic> data) async {
    return _provider.register(data);
  }
}
