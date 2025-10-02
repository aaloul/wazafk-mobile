import '../../model/ApiResponse.dart';
import '../../networking/services/account/otp_service.dart';

class OtpRepository {
  final _provider = OtpService();

  Future<ApiResponse> sendOTP(String channel) async {
    return _provider.sendOTP(channel);
  }

  Future<ApiResponse> verifyOTP(String channel, String otp) async {
    return _provider.verifyOTP(channel, otp);
  }
}
