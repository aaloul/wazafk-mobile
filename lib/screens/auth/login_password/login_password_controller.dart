import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/repository/account/login_repository.dart';

import '../../../utils/utils.dart';

class LoginPasswordController extends GetxController {
  final LoginRepository _loginRepository = LoginRepository();

  final passwordController = TextEditingController();
  var isLoading = false.obs;

  String mobile = '';

  @override
  void onInit() {
    super.onInit();
    mobile = Get.arguments?['mobile'] ?? '';
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (passwordController.text.isEmpty) {
      constants.showSnackBar('Password is required', SnackBarStatus.ERROR);
      return;
    }

    isLoading(true);
    try {
      final response = await _loginRepository.login(
        mobile,
        passwordController.text,
      );

      if (response.success ?? false) {
        constants.showSnackBar(
          response.message ?? 'Login successful',
          SnackBarStatus.SUCCESS,
        );
        Get.toNamed(
          RouteConstant.verificationScreen,
          arguments: {'mobile': mobile, 'page': 'login'},
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Login failed',
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
