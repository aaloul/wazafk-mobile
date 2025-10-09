import '../../../model/ApiResponse.dart';
import '../../../model/VerifyGuestResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class OtpService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendOTP({required String channel}) async {
    final Map<String, dynamic> body = {'channel': channel};
    final response = await _helper.post(Endpoints.sendOTP, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> sendGuestOTP(
      {required String channel, required String recipient}) async {
    final Map<String, dynamic> body = {
      'channel': channel,
      'recipient': recipient,
    };
    final response = await _helper.post(Endpoints.sendGuestOTP, body);
    return ApiResponse.fromJson(response);
  }

  Future<VerifyGuestResponse> verifyGuestOTP(
      {required String channel, required String recipient, required String otp}) async {
    final Map<String, dynamic> body = {
      'channel': channel,
      'recipient': recipient,
      'otp': otp,
    };
    final response = await _helper.post(Endpoints.verifyGuestOTP, body);
    return VerifyGuestResponse.fromJson(response);
  }

  Future<ApiResponse> verifyOTP(
      {required String channel, required String otp}) async {
    final Map<String, dynamic> body = {'channel': channel, 'otp': otp};
    final response = await _helper.post(Endpoints.verifyOTP, body);
    return ApiResponse.fromJson(response);
  }
}
