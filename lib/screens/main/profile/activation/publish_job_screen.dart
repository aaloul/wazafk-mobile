import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'components/activation_banner.dart';
import 'components/breakdown_card.dart';
import 'components/flow_confirm_button.dart';
import 'components/wallet_balance_card.dart';

class PublishJobArgs {
  const PublishJobArgs({
    required this.jobPostFee,
    required this.extraSkillsPrice,
    required this.extraSkillsCount,
    required this.totalToday,
    required this.isFirstPost,
    required this.step,
    required this.totalSteps,
    required this.onConfirm,
    required this.onEdit,
  });

  final double jobPostFee;
  final double extraSkillsPrice;
  final int extraSkillsCount;
  final double totalToday;
  final bool isFirstPost;
  final int step;
  final int totalSteps;
  final Future<void> Function() onConfirm;
  final VoidCallback onEdit;
}

/// "Publish 2 / 2" — the last step of posting a job.
///
/// Three states, per the design:
///  * nothing to pay (first post is free, p194) — promo banner, discounted
///    breakdown and the "after this it costs …" note;
///  * payable and the wallet covers it — wallet card plus the breakdown;
///  * payable and the wallet is short (p232) — shortfall note, wallet card with
///    the LOW badge, fee / available / charge-today breakdown, the suggested
///    top-up hint and a "Top up and Publish" button.
class PublishJobScreen extends StatelessWidget {
  const PublishJobScreen({super.key});

  String _balanceText() {
    try {
      return Get.find<HomeController>().walletBalance.value;
    } catch (_) {
      return '';
    }
  }

  static String _money(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as PublishJobArgs;
    final colors = context.resources.color;
    final strings = context.resources.strings;

    final balanceText = _balanceText();
    final balance = double.tryParse(balanceText) ?? 0;
    final isFree = args.totalToday <= 0;
    final available = math.min(balance, args.totalToday);
    final shortfall = args.totalToday - available;
    final isShort = !isFree && shortfall > 0;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
              hasBack: true,
              title: strings.publishLabel,
              endWidget: PrimaryText(
                text: '${args.step} / ${args.totalSteps}',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: colors.colorGrey,
              ),
            ),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    if (isShort) ...[
                      _ShortfallNote(
                        cost: _money(args.totalToday),
                        shortfall: _money(shortfall),
                      ),
                      const SizedBox(height: 12),
                    ] else if (args.isFirstPost) ...[
                      ActivationBanner(
                        title: strings.firstJobPostOnUs,
                        subtitle: strings.publishInstantly,
                        isPromo: true,
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (!isFree) ...[
                      WalletBalanceCard(
                        balance: balanceText,
                        hasEnough: !isShort,
                        showLowBadge: true,
                      ),
                      const SizedBox(height: 12),
                    ],

                    BreakdownCard(
                      items: _breakdown(context, args, isShort, available),
                      totalLabel:
                          isShort ? strings.chargeToday : strings.totalToday,
                      totalValue: isShort
                          ? '${_money(shortfall)}+'
                          : isFree
                              ? 'FREE'
                              : _money(args.totalToday),
                      totalIsFree: isFree,
                    ),

                    if (isShort) ...[
                      const SizedBox(height: 12),
                      _HintCard(
                        text: strings.suggestedTopUpNote(
                          _suggestedTopUp(args.jobPostFee, shortfall),
                        ),
                        leading: Image.asset(AppIcons.bulbBadge, width: 34),
                      ),
                    ] else if (args.isFirstPost) ...[
                      const SizedBox(height: 12),
                      _HintCard(
                        text: strings.afterThisJobCosts,
                        leading: Container(
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
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: isShort
                  ? FlowConfirmButton(
                      title: strings.topUpAndPublish,
                      onConfirm: () async {
                        await Get.toNamed(RouteConstant.topUpScreen);
                      },
                    )
                  : FlowConfirmButton(
                      title: strings.publishLabel,
                      onConfirm: args.onConfirm,
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

  List<BreakdownLineItem> _breakdown(
    BuildContext context,
    PublishJobArgs args,
    bool isShort,
    double available,
  ) {
    final strings = context.resources.strings;
    final extraSkills = args.extraSkillsPrice > 0
        ? BreakdownLineItem(
            label: '${strings.extraSkills} (x${args.extraSkillsCount})',
            amount: _money(args.extraSkillsPrice),
          )
        : null;

    if (isShort) {
      // Fee and what the wallet already covers (design p232).
      return [
        BreakdownLineItem(
          label: strings.jobPostFee,
          amount: _money(args.jobPostFee),
        ),
        if (extraSkills != null) extraSkills,
        BreakdownLineItem(
          label: strings.availableLabel,
          amount: _money(available),
        ),
      ];
    }

    if (args.isFirstPost) {
      // Fee struck through and cancelled by the promo (design p194).
      return [
        BreakdownLineItem(
          label: strings.jobPostFee,
          amount: _money(args.jobPostFee),
          strikethrough: true,
        ),
        BreakdownLineItem(
          label: strings.firstJobPostPromo,
          amount: '-${_money(args.jobPostFee)}',
          discount: true,
        ),
        if (extraSkills != null) extraSkills,
      ];
    }

    return [
      BreakdownLineItem(
        label: strings.jobPostFee,
        amount: _money(args.jobPostFee),
      ),
      if (extraSkills != null) extraSkills,
    ];
  }

  /// Rounds "what's missing plus one more post" up to the nearest \$5, matching
  /// the design's "\$5 covers this post plus another with change".
  static String _suggestedTopUp(double fee, double shortfall) {
    final rounded = ((shortfall + fee) / 5).ceil() * 5;
    return '\$${math.max(5, rounded)}';
  }
}

/// "Posting this job costs $2. You're $1.50 short…" — the shortfall in red.
class _ShortfallNote extends StatelessWidget {
  const _ShortfallNote({required this.cost, required this.shortfall});

  final String cost;
  final String shortfall;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final note =
        context.resources.strings.jobPostShortfallNote(cost, shortfall);

    var isRed = false;
    final spans = <TextSpan>[];
    for (final part in note.split(RegExp(r'\{/?r\}'))) {
      if (part.isNotEmpty) {
        spans.add(
          TextSpan(
            text: part,
            style: isRed ? TextStyle(color: colors.colorRed2) : null,
          ),
        );
      }
      isRed = !isRed;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colors.colorPrimaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: 14,
            height: 1.35,
            color: colors.colorBlack4,
          ),
          children: spans,
        ),
      ),
    );
  }
}

/// White card with a leading badge and a short note.
class _HintCard extends StatelessWidget {
  const _HintCard({required this.text, required this.leading});

  final String text;
  final Widget leading;

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
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryText(
              text: text,
              fontSize: 13,
              textColor: colors.colorBlack4,
            ),
          ),
        ],
      ),
    );
  }
}
