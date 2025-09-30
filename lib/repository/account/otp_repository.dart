import '../../model/ApiResponse.dart';
import '../../networking/services/account/otp_service.dart';

class OtpRepository {
  final _provider = OtpService();

  Future<ApiResponse> sendOTP(String mobile) async {
    return _provider.sendOTP(mobile);
  }

  Future<ApiResponse> verifyOTP(String mobile, String otp) async {
    return _provider.verifyOTP(mobile, otp);
  }
}
