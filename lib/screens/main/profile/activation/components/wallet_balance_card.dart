import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

/// Inline wallet-balance card with either an "ENOUGH ✓" badge or a
/// "Top Up +" pill on the right. Used inside activation / publish flows
/// (Figma p191, p204, p223) so the user knows in-context whether they need
/// to top up before confirming.
class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.hasEnough,
  });

  final String balance;
  final bool hasEnough;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                  text: strings.walletBalanceCaps,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  textColor: colors.colorWhite,
                ),
                const SizedBox(height: 4),
                PrimaryText(
                  text: '\$${balance.isEmpty ? '0.00' : balance}',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorWhite,
                ),
              ],
            ),
          ),
          if (hasEnough)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.colorWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryText(
                    text: strings.enoughBadge,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorPrimary,
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    AppIcons.checkCircle,
                    width: 12,
                    color: colors.colorPrimary,
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(RouteConstant.topUpScreen),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.colorWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PrimaryText(
                  text: strings.topUpPill,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
