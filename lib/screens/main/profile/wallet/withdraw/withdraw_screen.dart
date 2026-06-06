import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'withdraw_controller.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WithdrawController());
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.withdraw),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _BalanceCard(balance: controller.balance),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: strings.withdrawAmount,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    textColor: colors.colorBlack,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.colorWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.colorGrey4, width: 1),
                    ),
                    child: TextField(
                      controller: controller.amount,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        ),
                      ],
                      onChanged: (_) => controller.update(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colors.colorBlack,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: strings.enterAmount,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Obx(
                () => controller.isSubmitting.value
                    ? const ProgressBar()
                    : GetBuilder<WithdrawController>(
                        builder: (c) => PrimaryButton(
                          title: strings.withdraw,
                          color: c.canSubmit
                              ? colors.colorPrimary
                              : colors.colorGrey2,
                          onPressed: c.submit,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.colorPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: strings.yourBalance,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  textColor: colors.colorWhite,
                ),
                const SizedBox(height: 4),
                PrimaryText(
                  text: '\$${balance.isEmpty ? '0.00' : balance}',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorWhite,
                ),
              ],
            ),
          ),
          Image.asset(AppIcons.logoW, width: 56, height: 56),
        ],
      ),
    );
  }
}
