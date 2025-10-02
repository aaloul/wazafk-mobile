import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class OtpService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendOTP(String channel) async {
    final Map<String, dynamic> body = {'channel': channel};
    final response = await _helper.post(Endpoints.sendOTP, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> verifyOTP(String channel, String otp) async {
    final Map<String, dynamic> body = {'channel': channel, 'otp': otp};
    final response = await _helper.post(Endpoints.verifyOTP, body);
    return ApiResponse.fromJson(response);
  }
}
