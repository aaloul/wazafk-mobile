import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'top_up_controller.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopUpController());
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.topUpTitle),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: GetBuilder<TopUpController>(
                builder: (c) => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    _BalanceCard(balance: c.balance),
                    const SizedBox(height: 16),
                    for (int i = 0; i < c.plans.length; i++) ...[
                      _PlanCard(
                        plan: c.plans[i],
                        selected: c.selectedPlanIndex.value == i,
                        onTap: () => c.selectPlan(i),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 6),
                    PrimaryText(
                      text: strings.otherAmount,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorBlack,
                    ),
                    const SizedBox(height: 8),
                    _OtherAmountField(controller: c),
                    const SizedBox(height: 16),
                    PrimaryText(
                      text: strings.paymentMethod,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorBlack,
                    ),
                    const SizedBox(height: 8),
                    _PaymentMethodRow(controller: c),
                    const SizedBox(height: 12),
                    _PromoCard(controller: c),
                    const SizedBox(height: 12),
                    _TotalsCard(controller: c),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Obx(
                () => controller.isSubmitting.value
                    ? const ProgressBar()
                    : GetBuilder<TopUpController>(
                        builder: (c) => PrimaryButton(
                          title: strings.topUpTitle,
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final TopUpPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? colors.colorPrimaryLight : colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.colorPrimary : colors.colorGrey4,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: '\$${plan.amount.toStringAsFixed(0)}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorBlack,
                  ),
                  const SizedBox(height: 2),
                  PrimaryText(
                    text: plan.description,
                    fontSize: 12,
                    textColor: colors.colorGrey,
                  ),
                ],
              ),
            ),
            if (plan.bestValue)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.colorPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: PrimaryText(
                  text: strings.bestValue,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorWhite,
                ),
              ),
            const SizedBox(width: 10),
            _RadioDot(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.colorPrimary : Colors.transparent,
        border: Border.all(
          color: selected ? colors.colorPrimary : colors.colorGrey4,
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.colorWhite,
                ),
              ),
            )
          : null,
    );
  }
}

class _OtherAmountField extends StatelessWidget {
  const _OtherAmountField({required this.controller});

  final TopUpController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.colorGrey4, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: strings.enterAmount,
            fontSize: 11,
            textColor: colors.colorGrey,
          ),
          TextField(
            controller: controller.otherAmount,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: controller.clearPlanIfTypingOther,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.colorBlack,
            ),
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '0',
              contentPadding: EdgeInsets.symmetric(vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({required this.controller});

  final TopUpController controller;

  Future<void> _onChange(BuildContext context) async {
    final picked = await SheetHelper.showPaymentMethodSheet(
      context,
      methods: controller.paymentMethods,
    );
    if (picked != null) {
      controller.selectPaymentMethod(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.colorGrey4, width: 1),
      ),
      child: Obx(() {
        final method = controller.selectedMethod.value;
        return Row(
          children: [
            SizedBox(
              width: 44,
              height: 28,
              child: Image.asset(method.brandIcon, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: method.name,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.colorBlack,
                  ),
                  const SizedBox(height: 2),
                  PrimaryText(
                    text: '${strings.endingWith} ${method.lastDigits}',
                    fontSize: 12,
                    textColor: colors.colorGrey,
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onChange(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.colorWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.colorPrimary, width: 1),
                ),
                child: PrimaryText(
                  text: strings.change,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: colors.colorPrimary,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.controller});

  final TopUpController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.colorGrey4, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_outlined,
                  size: 18, color: colors.colorPrimary),
              const SizedBox(width: 8),
              PrimaryText(
                text: strings.addPromoCode,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textColor: colors.colorBlack,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.colorWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.colorGrey4, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: strings.promoCode,
                        fontSize: 11,
                        textColor: colors.colorGrey,
                      ),
                      TextField(
                        controller: controller.promoCode,
                        onSubmitted: (_) => controller.applyPromo(),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors.colorBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.clearPromo,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete_outline,
                    color: colors.colorRed2,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Obx(() => controller.isPromoApplied.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: colors.colorGreen6),
                      const SizedBox(width: 6),
                      PrimaryText(
                        text: '30% off',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: colors.colorBlack,
                      ),
                      const Spacer(),
                      PrimaryText(
                        text:
                            '-\$${controller.promoDiscount.value.toStringAsFixed(2)}',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: colors.colorPrimary,
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.controller});

  final TopUpController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.colorGrey4, width: 1),
      ),
      child: Column(
        children: [
          _TotalRow(
            label: strings.subtotal,
            value: '\$${controller.subtotal.toStringAsFixed(2)}',
          ),
          if (controller.isPromoApplied.value) ...[
            const SizedBox(height: 6),
            _TotalRow(
              label: strings.promoCode,
              value:
                  '-\$${controller.promoDiscount.value.toStringAsFixed(2)}',
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.colorPrimaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryText(
                    text: strings.total,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorPrimary,
                  ),
                ),
                PrimaryText(
                  text: '\$${controller.total.toStringAsFixed(2)}',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Row(
      children: [
        Expanded(
          child: PrimaryText(
            text: label,
            fontSize: 13,
            textColor: colors.colorGrey,
          ),
        ),
        PrimaryText(
          text: value,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          textColor: colors.colorBlack,
        ),
      ],
    );
  }
}
