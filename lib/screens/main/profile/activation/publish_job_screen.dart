import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'components/activation_banner.dart';
import 'components/breakdown_card.dart';

class PublishJobArgs {
  const PublishJobArgs({
    required this.jobPostFee,
    required this.extraSkillsPrice,
    required this.totalToday,
    required this.isFirstPost,
    required this.step,
    required this.totalSteps,
    required this.onConfirm,
    required this.onEdit,
  });

  final double jobPostFee;
  final double extraSkillsPrice;
  final double totalToday;
  final bool isFirstPost;
  final int step;
  final int totalSteps;
  final VoidCallback onConfirm;
  final VoidCallback onEdit;
}

class PublishJobScreen extends StatelessWidget {
  const PublishJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as PublishJobArgs;
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final isFree = args.totalToday <= 0;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                TopHeader(hasBack: true, title: strings.publishLabel),
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: PrimaryText(
                      text: '${args.step} / ${args.totalSteps}',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: colors.colorGrey,
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    if (args.isFirstPost)
                      ActivationBanner(
                        title: strings.firstJobPostOnUs,
                        subtitle: strings.publishInstantly,
                        isPromo: true,
                      ),
                    if (args.isFirstPost) const SizedBox(height: 12),
                    BreakdownCard(
                      items: args.isFirstPost
                          ? [
                              BreakdownLineItem(
                                label: strings.jobPostFee,
                                amount:
                                    '\$${args.jobPostFee.toStringAsFixed(2)}',
                                strikethrough: true,
                              ),
                              BreakdownLineItem(
                                label: strings.firstJobPostPromo,
                                amount:
                                    '-\$${args.jobPostFee.toStringAsFixed(2)}',
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
                                label: strings.jobPostFee,
                                amount:
                                    '\$${args.jobPostFee.toStringAsFixed(2)}',
                              ),
                              if (args.extraSkillsPrice > 0)
                                BreakdownLineItem(
                                  label: '${strings.extraSkills} (x2)',
                                  amount:
                                      '\$${args.extraSkillsPrice.toStringAsFixed(2)}',
                                ),
                            ],
                      totalLabel: strings.totalToday,
                      totalValue: isFree
                          ? 'FREE'
                          : '\$${args.totalToday.toStringAsFixed(2)}',
                      totalIsFree: isFree,
                    ),
                    if (args.isFirstPost) ...[
                      const SizedBox(height: 12),
                      _ClockHintCard(text: strings.afterThisJobCosts),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: PrimaryButton(
                title: strings.publishLabel,
                onPressed: () {
                  args.onConfirm();
                  Get.back();
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: args.onEdit,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: PrimaryText(
                  text: strings.editDetails,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  textColor: colors.colorBlack,
                  textAlign: TextAlign.center,
                  isUnderLined: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClockHintCard extends StatelessWidget {
  const _ClockHintCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
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
              text: text,
              fontSize: 12,
              textColor: colors.colorGrey,
            ),
          ),
        ],
      ),
    );
  }
}
