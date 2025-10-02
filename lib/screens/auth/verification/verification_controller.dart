import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/repository/account/otp_repository.dart';

import '../../../utils/utils.dart';

class VerificationController extends GetxController {
  final OtpRepository _otpRepository = OtpRepository();

  var isLoading = false.obs;
  var isResending = false.obs;
  var otp = ''.obs;

  String mobile = '';
  String? page;

  @override
  void onInit() {
    super.onInit();
    mobile = Get.arguments?['mobile'] ?? '';
    page = Get.arguments?['page'];
  }

  Future<void> verifyOTP() async {
    if (otp.value.isEmpty || otp.value.length < 4) {
      constants.showSnackBar('Please enter valid OTP', SnackBarStatus.ERROR);
      return;
    }

    isLoading(true);
    try {
      final response = await _otpRepository.verifyOTP("SMS", otp.value);

      if (response.success ?? false) {
        constants.showSnackBar(
          response.message ?? 'OTP verified successfully',
          SnackBarStatus.SUCCESS,
        );

        // Navigate based on the page
        if (page == 'login') {
          // Navigate to main navigation after login
          Get.offAllNamed(RouteConstant.createAccountScreen);
        } else {
          // Navigate to create account after registration OTP
          Get.toNamed(RouteConstant.createAccountScreen);
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'OTP verification failed',
          SnackBarStatus.ERROR,
        );
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> resendOTP() async {
    isResending(true);
    try {
      final response = await _otpRepository.sendOTP("SMS");

      if (response.success ?? false) {
        constants.showSnackBar(
          response.message ?? 'OTP sent successfully',
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to send OTP',
          SnackBarStatus.ERROR,
        );
      }
      isResending(false);
    } catch (e) {
      isResending(false);
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }
}
