import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/account/otp_repository.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../home/home_controller.dart';

class EditPhoneController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final OtpRepository _otpRepository = OtpRepository();

  final TextEditingController phoneController = TextEditingController();

  /// Dial code from the country picker, e.g. "+961". Defaults to Lebanon and is
  /// updated through [onCountryChanged].
  String cc = '+961';

  final RxBool isSendingOtp = false.obs;
  final RxBool isSubmittingOtp = false.obs;
  final RxnString phoneError = RxnString();

  @override
  void onInit() {
    super.onInit();
    phoneController.text = _localPart(Prefs.getMobile);
  }

  /// Strips a leading dial code from the stored mobile so the number field shows
  /// the national part (the picker shows the dial code separately).
  String _localPart(String stored) {
    var s = stored.trim();
    if (s.isEmpty) return '';
    if (s.startsWith('+')) {
      // Drop the leading "+961" (or current cc) if present.
      final digits = cc.replaceAll('+', '');
      if (s.startsWith('+$digits')) return s.substring(digits.length + 1);
      return s.substring(1);
    }
    return s;
  }

  String get newMobile => '$cc${phoneController.text.trim()}';

  void onCountryChanged(String? dialCode) {
    if (dialCode != null && dialCode.isNotEmpty) cc = dialCode;
  }

  /// Validates the entered number and sends an OTP to it. Returns true if the
  /// OTP was sent and the OTP sheet should be shown.
  Future<bool> validateAndSendOtp() async {
    phoneError.value = null;
    final number = phoneController.text.trim();

    if (number.isEmpty) {
      phoneError.value = 'Phone number is required';
      return false;
    }
    if (newMobile == Prefs.getMobile) {
      phoneError.value = 'This is your current number';
      return false;
    }

    return sendOtp();
  }

  Future<bool> sendOtp() async {
    try {
      isSendingOtp.value = true;
      final response = await _otpRepository.sendOTP(
        channel: 'SMS',
        recipient: newMobile,
      );
      if (response.success == true) return true;
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

  /// Verifies the OTP, then commits the new number through editProfile. Returns
  /// true on success so the screen can show the success sheet.
  Future<bool> submitOtp(String otp) async {
    if (otp.length < 4) {
      constants.showSnackBar('Enter the full code', SnackBarStatus.ERROR);
      return false;
    }
    try {
      isSubmittingOtp.value = true;

      // 1) Verify the OTP sent to the new number.
      final verify = await _otpRepository.verifyOTP(channel: 'SMS', otp: otp);
      if (verify.success != true) {
        constants.showSnackBar(
          verify.message ?? 'Failed to verify OTP',
          SnackBarStatus.ERROR,
        );
        return false;
      }

      // 2) Persist the new number via editProfile. The current profile fields
      //    are re-sent alongside `mobile` so nothing else is overwritten.
      final response = await _profileRepository.editProfile(_buildProfileData());
      if (response.success == true) {
        if (response.data != null) {
          Prefs.saveUser(response.data!);
        } else {
          Prefs.setMobile(newMobile);
        }
        try {
          Get.find<HomeController>().fetchProfile();
        } catch (_) {}
        return true;
      }
      constants.showSnackBar(
        response.message ?? 'Failed to update phone number',
        SnackBarStatus.ERROR,
      );
      return false;
    } catch (e) {
      constants.showSnackBar(
        'Error updating phone number: $e',
        SnackBarStatus.ERROR,
      );
      return false;
    } finally {
      isSubmittingOtp.value = false;
    }
  }

  /// Builds the editProfile payload from the cached profile plus the new mobile,
  /// mirroring [PersonalInformationController.updateProfile] so unrelated fields
  /// are preserved.
  Map<String, dynamic> _buildProfileData() {
    final data = <String, dynamic>{
      'first_name': Prefs.getFName,
      'last_name': Prefs.getLName,
      'info': Prefs.getInfo,
      'mobile': newMobile,
    };
    final title = Prefs.getProfileTitle;
    if (title.isNotEmpty && title != 'null') data['title'] = title;
    final website = Prefs.getWebsite;
    if (website.isNotEmpty && website != 'null') data['website'] = website;
    final gender = Prefs.getGender;
    if (gender.isNotEmpty) {
      data['gender'] = gender.substring(0, 1).toUpperCase();
    }
    final dob = Prefs.getDob;
    if (dob.isNotEmpty) data['date_of_birth'] = dob;
    return data;
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
