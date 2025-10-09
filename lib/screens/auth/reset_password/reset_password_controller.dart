import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/repository/account/password_repository.dart';

import '../../../utils/utils.dart';

class ResetPasswordController extends GetxController {
  final PasswordRepository _passwordRepository = PasswordRepository();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  String mobile = '';
  String token = '';

  @override
  void onInit() {
    super.onInit();
    mobile = Get.arguments?['mobile'] ?? '';
    token = Get.arguments?['token'] ?? '';
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }


  Future<void> confirmPasswordReset() async {
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
        token,
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
