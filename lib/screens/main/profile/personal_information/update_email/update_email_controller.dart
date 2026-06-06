import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/account/otp_repository.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../home/home_controller.dart';

class UpdateEmailController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final OtpRepository _otpRepository = OtpRepository();

  final TextEditingController emailController = TextEditingController();

  final RxBool isCheckingEmail = false.obs;
  final RxBool isSendingOtp = false.obs;
  final RxBool isSubmittingOtp = false.obs;
  final RxnString emailError = RxnString();

  @override
  void onInit() {
    super.onInit();
    emailController.text = Prefs.getEmail;
  }

  Future<bool> verifyEmailAndSendOtp() async {
    final email = emailController.text.trim();
    emailError.value = null;

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }
    if (!email.contains('@')) {
      emailError.value = 'Invalid email';
      return false;
    }
    if (email == Prefs.getEmail) {
      emailError.value = 'This is your current email';
      return false;
    }

    try {
      isCheckingEmail.value = true;
      final check = await _profileRepository.checkEmailExists(email);
      if (check.data?.exists == true) {
        emailError.value = Get.context != null
            ? 'The email is already taken.'
            : 'Email taken';
        return false;
      }
    } catch (e) {
      constants.showSnackBar('Error checking email: $e', SnackBarStatus.ERROR);
      return false;
    } finally {
      isCheckingEmail.value = false;
    }

    return sendOtp();
  }

  Future<bool> sendOtp() async {
    try {
      isSendingOtp.value = true;
      final response = await _otpRepository.sendOTP(
        channel: 'EMAIL',
        recipient: emailController.text.trim(),
      );
      if (response.success == true) {
        return true;
      }
      constants.showSnackBar(
        response.message ?? 'Failed to send OTP',
        SnackBarStatus.ERROR,
      );
      return false;
    } catch (e) {
      constants.showSnackBar('Error sending OTP: $e', SnackBarStatus.ERROR);
      return false;
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<bool> submitOtp(String otp) async {
    if (otp.length < 4) {
      constants.showSnackBar('Enter the full code', SnackBarStatus.ERROR);
      return false;
    }
    try {
      isSubmittingOtp.value = true;
      final response = await _profileRepository.editProfileEmail(
        email: emailController.text.trim(),
        otp: otp,
      );
      if (response.success == true) {
        final newEmail = emailController.text.trim();
        try {
          final home = Get.find<HomeController>();
          home.fetchProfile();
        } catch (_) {}
        constants.showSnackBar(
          response.message ?? 'Email updated',
          SnackBarStatus.SUCCESS,
        );
        Get.back(result: newEmail);
        return true;
      }
      constants.showSnackBar(
        response.message ?? 'Failed to verify OTP',
        SnackBarStatus.ERROR,
      );
      return false;
    } catch (e) {
      constants.showSnackBar(
        'Error verifying OTP: $e',
        SnackBarStatus.ERROR,
      );
      return false;
    } finally {
      isSubmittingOtp.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
