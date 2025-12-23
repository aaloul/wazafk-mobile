import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/account/password_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class ChangePasswordController extends GetxController {
  final _repository = PasswordRepository();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> changePassword() async {
    if (!_validateFields()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repository.changePassword(
        currentPasswordController.text,
        newPasswordController.text,
      );

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Password changed successfully',
          SnackBarStatus.SUCCESS,
        );
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to change password',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error changing password: $e',
        SnackBarStatus.ERROR,
      );
      print('Error changing password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateFields() {
    if (currentPasswordController.text.trim().isEmpty) {
      constants.showSnackBar(
        'Please enter current password',
        SnackBarStatus.ERROR,
      );
      return false;
    }
    if (newPasswordController.text.trim().isEmpty) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .newPasswordRequired, SnackBarStatus.ERROR);
      return false;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      constants.showSnackBar(
        'Please confirm new password',
        SnackBarStatus.ERROR,
      );
      return false;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .passwordsDoNotMatch, SnackBarStatus.ERROR);
      return false;
    }
    if (newPasswordController.text.length < 6) {
      constants.showSnackBar(
        'Password must be at least 6 characters',
        SnackBarStatus.ERROR,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
