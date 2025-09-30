import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class OtpService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendOTP(String mobile) async {
    final Map<String, dynamic> body = {'mobile': mobile};
    final response = await _helper.post(Endpoints.sendOTP, body);
    return response;
  }

  Future<ApiResponse> verifyOTP(String mobile, String otp) async {
    final Map<String, dynamic> body = {'mobile': mobile, 'otp': otp};
    final response = await _helper.post(Endpoints.verifyOTP, body);
    return response;
  }
}
