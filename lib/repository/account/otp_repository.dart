import '../../model/ApiResponse.dart';
import '../../model/VerifyGuestResponse.dart';
import '../../networking/services/account/otp_service.dart';

class OtpRepository {
  final _provider = OtpService();

  Future<ApiResponse> sendOTP({required String channel}) async {
    return _provider.sendOTP(channel: channel);
  }

  Future<ApiResponse> verifyOTP(
      {required String channel, required String otp}) async {
    return _provider.verifyOTP(channel: channel, otp: otp);
  }

  Future<ApiResponse> sendGuestOTP(
      {required String channel, required String recipient}) async {
    return _provider.sendGuestOTP(channel: channel, recipient: recipient);
  }

  Future<VerifyGuestResponse> verifyGuestOTP(
      {required String channel, required String otp, required String recipient}) async {
    return _provider.verifyGuestOTP(
        channel: channel, otp: otp, recipient: recipient);
  }
}
