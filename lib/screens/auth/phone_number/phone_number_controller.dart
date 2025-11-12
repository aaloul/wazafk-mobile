import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/member/check_member_repository.dart';

import '../../../constants/route_constant.dart';
import '../../../utils/utils.dart';

class PhoneNumberController extends GetxController {
  final CheckMemberRepository _checkMemberRepository = CheckMemberRepository();

  var isLoading = false.obs;
  String cc = '';

  TextEditingController phoneController = TextEditingController();

  Future<void> checkMemberExists() async {
    String mobile = phoneController.text.toString();

    if (mobile.trim().isEmpty) {
      return;
    }

    isLoading(true);
    try {
      final response = await _checkMemberRepository.checkMemberExists(
        mobile: cc + mobile,
      );
      if (response.success ?? false) {
        if (response.data?.exists ?? false) {
          Get.toNamed(
            RouteConstant.loginPasswordScreen,
            arguments: {"mobile": cc + mobile},
          );
        } else {
          Get.toNamed(
            RouteConstant.verificationScreen,
            arguments: {'page': "login", "mobile": cc + mobile},
          );
        }
      } else {
        constants.showSnackBar(
          getErrorMessage(response.message.toString()).toString(),
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

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}
}
