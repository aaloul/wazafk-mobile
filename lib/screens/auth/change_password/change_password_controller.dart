import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/repository/account/password_repository.dart';

import '../../../utils/utils.dart';

class ChangePasswordController extends GetxController {
  final PasswordRepository _passwordRepository = PasswordRepository();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  var isLoading = false.obs;

  String mobile = '';

  @override
  void onInit() {
    super.onInit();
    mobile = Get.arguments?['mobile'] ?? '';
    // Automatically request OTP when screen loads
    if (mobile.isNotEmpty) {
      requestPasswordReset();
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }

  Future<void> requestPasswordReset() async {
    if (mobile.isEmpty) {
      constants.showSnackBar('Mobile number is required', SnackBarStatus.ERROR);
      return;
    }

    isLoading(true);
    try {
      final response = await _passwordRepository.forgotPasswordRequest(mobile);

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
      isLoading(false);
    } catch (e) {
      isLoading(false);
      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> confirmPasswordReset() async {
    if (otpController.text.isEmpty) {
      constants.showSnackBar('OTP is required', SnackBarStatus.ERROR);
      return;
    }

    if (newPasswordController.text.isEmpty) {
      constants.showSnackBar('New password is required', SnackBarStatus.ERROR);
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      constants.showSnackBar(
        'Confirm password is required',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      constants.showSnackBar('Passwords do not match', SnackBarStatus.ERROR);
      return;
    }

    isLoading(true);
    try {
      final response = await _passwordRepository.forgotPasswordConfirm(
        mobile,
        otpController.text,
        newPasswordController.text,
      );

      if (response.success ?? false) {
        constants.showSnackBar(
          response.message ?? 'Password changed successfully',
          SnackBarStatus.SUCCESS,
        );
        // Navigate to login screen
        Get.offAllNamed(
          RouteConstant.loginPasswordScreen,
          arguments: {'mobile': mobile},
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to change password',
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
}
