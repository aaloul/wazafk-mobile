import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'components/activation_banner.dart';
import 'components/breakdown_card.dart';
import 'components/wallet_balance_card.dart';

class ActivateServiceArgs {
  const ActivateServiceArgs({
    required this.monthlyPrice,
    required this.extraSkillsPrice,
    required this.totalToday,
    required this.isFirstService,
    required this.step,
    required this.totalSteps,
    required this.onConfirm,
  });

  final double monthlyPrice;
  final double extraSkillsPrice;
  final double totalToday;
  final bool isFirstService;
  final int step;
  final int totalSteps;
  final VoidCallback onConfirm;
}

class ActivateServiceScreen extends StatelessWidget {
  const ActivateServiceScreen({super.key});

  String _balance() {
    try {
      return Get.find<HomeController>().walletBalance.value;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ActivateServiceArgs;
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final balanceStr = _balance();
    final balance = double.tryParse(balanceStr) ?? 0;
    final hasEnough = balance >= args.totalToday;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: strings.activateService,
              step: args.step,
              total: args.totalSteps,
            ),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    if (args.isFirstService)
                      ActivationBanner(
                        title: strings.firstServiceOnUs,
                        subtitle: strings.renewAtAfter90Days,
                        isPromo: true,
                      )
                    else
                      ActivationBanner(
                        title:
                            '${strings.keepServiceLive} \$${args.monthlyPrice.toStringAsFixed(0)}/month.',
                        subtitle: strings.serviceRenewsMonthly,
                      ),
                    const SizedBox(height: 12),
                    BreakdownCard(
                      items: args.isFirstService
                          ? [
                              BreakdownLineItem(
                                label:
                                    '${strings.subscriptionMo} (mo. 3)',
                                amount:
                                    '\$${args.monthlyPrice.toStringAsFixed(2)}',
                                strikethrough: true,
                              ),
                              BreakdownLineItem(
                                label: strings.firstServicePromo,
                                amount:
                                    '-\$${args.monthlyPrice.toStringAsFixed(2)}',
                                discount: true,
                              ),
                              if (args.extraSkillsPrice > 0)
                                BreakdownLineItem(
                                  label: '${strings.extraSkills} (x2)',
                                  amount:
                                      '\$${args.extraSkillsPrice.toStringAsFixed(2)}',
                                ),
                            ]
                          : [
                              BreakdownLineItem(
                                label: strings.serviceMonthly,
                                amount:
                                    '\$${args.monthlyPrice.toStringAsFixed(2)}',
                              ),
                              if (args.extraSkillsPrice > 0)
                                BreakdownLineItem(
                                  label: '${strings.extraSkills} (x2)',
                                  amount:
                                      '\$${args.extraSkillsPrice.toStringAsFixed(2)}',
                                ),
                            ],
                      totalLabel: strings.totalToday,
                      totalValue:
                          '\$${args.totalToday.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 12),
                    WalletBalanceCard(
                      balance: balanceStr,
                      hasEnough: hasEnough,
                    ),
                    if (!args.isFirstService) ...[
                      const SizedBox(height: 12),
                      _RenewalNoteCard(),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: PrimaryButton(
                title: strings.activateService,
                color: hasEnough
                    ? colors.colorPrimary
                    : colors.colorGrey2,
                onPressed: () {
                  if (!hasEnough) return;
                  args.onConfirm();
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.step,
    required this.total,
  });

  final String title;
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Stack(
      children: [
        TopHeader(hasBack: true, title: title),
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: PrimaryText(
              text: '$step / $total',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor: colors.colorGrey,
            ),
          ),
        ),
      ],
    );
  }
}

class _RenewalNoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.colorPrimary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppIcons.clock,
              width: 16,
              color: colors.colorWhite,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryText(
              text: strings.nextRenewalHint,
              fontSize: 12,
              textColor: colors.colorGrey,
            ),
          ),
        ],
      ),
    );
  }
}
