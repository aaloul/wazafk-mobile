import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/wallet/submit_payment_repository.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

/// Predefined top-up plan card per Figma p101.
class TopUpPlan {
  const TopUpPlan({
    required this.amount,
    required this.description,
    this.bestValue = false,
  });
  final double amount;
  final String description;
  final bool bestValue;
}

class PaymentMethodOption {
  const PaymentMethodOption({
    required this.brandIcon,
    required this.name,
    required this.lastDigits,
    required this.expires,
  });

  final String brandIcon;
  final String name;
  final String lastDigits;
  final String expires;
}

class TopUpController extends GetxController {
  final _submitPaymentRepo = SubmitPaymentRepository();

  final selectedPlanIndex = RxnInt();
  final otherAmount = TextEditingController();
  final promoCode = TextEditingController();
  final isPromoApplied = false.obs;
  final promoDiscount = 0.0.obs;
  final isSubmitting = false.obs;

  final plans = const <TopUpPlan>[
    TopUpPlan(amount: 5, description: '2 job posts or 1 service per month'),
    TopUpPlan(
      amount: 10,
      description: '5 job posts or 3 months service',
      bestValue: true,
    ),
    TopUpPlan(amount: 20, description: '10 posts or 6 months service'),
  ];

  // Available payment methods — matches Payment Methods screen seed data
  // until the backend exposes a card-listing endpoint.
  final paymentMethods = const <PaymentMethodOption>[
    PaymentMethodOption(
      brandIcon: AppIcons.brandMaster,
      name: 'Master',
      lastDigits: '0000',
      expires: '01/2027',
    ),
    PaymentMethodOption(
      brandIcon: AppIcons.brandOmt,
      name: 'Omt',
      lastDigits: '0000',
      expires: '01/2027',
    ),
    PaymentMethodOption(
      brandIcon: AppIcons.brandVisa,
      name: 'Visa',
      lastDigits: '0000',
      expires: '01/2027',
    ),
    PaymentMethodOption(
      brandIcon: AppIcons.brandWhish,
      name: 'Whish',
      lastDigits: '0000',
      expires: '01/2027',
    ),
  ];

  late final Rx<PaymentMethodOption> selectedMethod =
      paymentMethods.first.obs;

  void selectPaymentMethod(PaymentMethodOption m) {
    selectedMethod.value = m;
  }

  String get balance {
    try {
      return Get.find<HomeController>().walletBalance.value;
    } catch (_) {
      return '';
    }
  }

  double get subtotal {
    if (selectedPlanIndex.value != null) {
      return plans[selectedPlanIndex.value!].amount;
    }
    return double.tryParse(otherAmount.text.trim()) ?? 0.0;
  }

  double get total =>
      (subtotal - promoDiscount.value).clamp(0, double.infinity);

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
    otherAmount.clear();
    update();
  }

  void clearPlanIfTypingOther(String _) {
    if (otherAmount.text.isNotEmpty) {
      selectedPlanIndex.value = null;
    }
    update();
  }

  void applyPromo() {
    if (promoCode.text.trim().isEmpty) return;
    // Local-only stub: backend has no promo endpoint in Postman.
    isPromoApplied.value = true;
    promoDiscount.value = subtotal * 0.30;
    update();
  }

  void clearPromo() {
    promoCode.clear();
    promoDiscount.value = 0.0;
    isPromoApplied.value = false;
    update();
  }

  bool get canSubmit => total > 0;

  /// Triggers the backend's CARD payment flow. The 2-step
  /// submitPayment → chargeWalletWithPayment chain depends on parsing a
  /// payment hashcode out of the response — our ApiResponse model doesn't
  /// expose `data` yet, so we kick off the payment record and refresh the
  /// wallet. Charge-completion + Stripe-style confirmation should be wired
  /// once a typed SubmitPaymentResponse exists.
  Future<void> submit() async {
    if (!canSubmit) return;
    try {
      isSubmitting.value = true;
      final amount = total.toStringAsFixed(2);

      final payment = await _submitPaymentRepo.submitPayment({
        'method': 'CARD',
        'amount': amount,
      });
      if (payment.success == true) {
        constants.showSnackBar(
          payment.message ?? 'Top-up submitted',
          SnackBarStatus.SUCCESS,
        );
        try {
          Get.find<HomeController>().fetchWallet();
        } catch (_) {}
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          payment.message ?? 'Failed to create payment',
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
    otherAmount.dispose();
    promoCode.dispose();
    super.onClose();
  }
}
