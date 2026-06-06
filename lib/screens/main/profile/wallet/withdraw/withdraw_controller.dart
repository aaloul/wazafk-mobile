import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/wallet/cash_request_repository.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/utils.dart';

class WithdrawController extends GetxController {
  final _repo = CashRequestRepository();
  final amount = TextEditingController();
  final isSubmitting = false.obs;

  String get balance {
    try {
      return Get.find<HomeController>().walletBalance.value;
    } catch (_) {
      return '';
    }
  }

  bool get canSubmit {
    final value = double.tryParse(amount.text.trim());
    return value != null && value > 0;
  }

  Future<void> submit() async {
    final value = double.tryParse(amount.text.trim());
    if (value == null || value <= 0) {
      constants.showSnackBar('Enter a valid amount', SnackBarStatus.ERROR);
      return;
    }
    try {
      isSubmitting.value = true;
      final response = await _repo.submitCashRequest(
        provider: 'OMT',
        type: 'OUT',
        amount: value.toStringAsFixed(2),
      );
      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Withdraw request submitted',
          SnackBarStatus.SUCCESS,
        );
        try {
          Get.find<HomeController>().fetchWallet();
        } catch (_) {}
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to submit',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error: $e', SnackBarStatus.ERROR);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    amount.dispose();
    super.onClose();
  }
}
