import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/profile/wallet/top_up/top_up_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Bottom sheet that lets the user swap the payment method on the Top Up
/// screen. Opens from the "Change" pill next to the current method and
/// closes on tap. Currently lists the same brand seed (Master / Omt / Visa /
/// Whish) as Payment Methods until a backend card-listing endpoint exists.
class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({super.key, required this.methods});

  final List<PaymentMethodOption> methods;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            PrimaryText(
              text: strings.paymentMethod,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack,
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < methods.length; i++) ...[
              _Row(
                method: methods[i],
                onTap: () => Get.back(result: methods[i]),
              ),
              if (i != methods.length - 1)
                Container(
                  height: 1,
                  margin: const EdgeInsetsDirectional.only(start: 76),
                  color: colors.colorGrey4,
                ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.method, required this.onTap});

  final PaymentMethodOption method;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 28,
              child: Image.asset(method.brandIcon, fit: BoxFit.contain),
            ),
            const SizedBox(width: 14),
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
            PrimaryText(
              text: '${strings.expires} ${method.expires}',
              fontSize: 12,
              textColor: colors.colorGrey,
            ),
          ],
        ),
      ),
    );
  }
}
