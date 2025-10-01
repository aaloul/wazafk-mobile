import '../../../model/LoginResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RegisterService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginResponse> register(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.register, data);
    return LoginResponse.fromJson(response);
  }
}
