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

/// Copy for one flavour of the summary step — job post (design p194 / p232) or
/// work pack. Built by the controller so the wording stays in the string files.
class PublishSummaryLabels {
  const PublishSummaryLabels({
    required this.title,
    required this.feeLabel,
    required this.promoTitle,
    required this.promoSubtitle,
    required this.promoLabel,
    required this.afterNote,
    required this.shortfallNote,
    required this.confirmLabel,
    required this.topUpConfirmLabel,
    required this.editLabel,
  });

  final String title;
  final String feeLabel;
  final String promoTitle;
  final String promoSubtitle;
  final String promoLabel;

  /// "After this, posting a job costs $x…"
  final String Function(String price) afterNote;

  /// "Posting this job costs $x. You're {r}$y{/r} short…"
  final String Function(String cost, String short) shortfallNote;

  final String confirmLabel;
  final String topUpConfirmLabel;
  final String editLabel;
}

class PublishSummaryArgs {
  const PublishSummaryArgs({
    required this.labels,
    required this.fee,
    required this.totalToday,
    required this.isFirst,
    required this.step,
    required this.totalSteps,
    required this.onConfirm,
    required this.onEdit,
    this.extrasPrice = 0,
    this.extrasCount = 0,
    this.extrasLabel,
    this.showPromo = true,
  });

  final PublishSummaryLabels labels;

  /// Price of the thing being posted, before any promo.
  final double fee;

  /// Extra add-ons billed alongside it (skills on a job post).
  final double extrasPrice;
  final int extrasCount;
  final String? extrasLabel;

  final double totalToday;

  /// Inside the free allowance — the total comes out FREE.
  final bool isFirst;

  /// Whether the "first one on us" promo presentation (banner, struck-through
  /// fee, promo line and the "after this it costs…" note) is shown. Flows
  /// without a first-time offer pass false and just show the total.
  final bool showPromo;

  final int step;
  final int totalSteps;
  final Future<void> Function() onConfirm;
  final VoidCallback onEdit;
}

/// Last step of a posting flow: promo banner or shortfall note, the cost
/// breakdown, the wallet card when something is payable, and the confirm /
/// "top up first" action.
class PublishSummaryScreen extends StatelessWidget {
  const PublishSummaryScreen({super.key});

  static String _money(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as PublishSummaryArgs;

    // Rebuilds when the wallet changes — coming back from a top-up flips the
    // short/covered state without leaving the screen.
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      return Obx(() => _body(context, args, home.walletBalance.value));
    }
    return _body(context, args, '');
  }

  Widget _body(
    BuildContext context,
    PublishSummaryArgs args,
    String balanceText,
  ) {
    final labels = args.labels;
    final colors = context.resources.color;
    final strings = context.resources.strings;

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
              title: labels.title,
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
                        note: labels.shortfallNote(
                          _money(args.totalToday),
                          _money(shortfall),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ] else if (args.isFirst && args.showPromo) ...[
                      ActivationBanner(
                        title: labels.promoTitle,
                        subtitle: labels.promoSubtitle,
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
                          _suggestedTopUp(args.fee, shortfall),
                        ),
                        leading: Image.asset(AppIcons.bulbBadge, width: 34),
                      ),
                    ] else if (args.isFirst && args.showPromo) ...[
                      const SizedBox(height: 12),
                      _HintCard(
                        text: labels.afterNote(_money(args.fee)),
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
                      title: labels.topUpConfirmLabel,
                      onConfirm: () async {
                        await Get.toNamed(RouteConstant.topUpScreen);
                      },
                    )
                  : FlowConfirmButton(
                      title: labels.confirmLabel,
                      onConfirm: args.onConfirm,
                    ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: args.onEdit,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: PrimaryText(
                  text: labels.editLabel,
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
    PublishSummaryArgs args,
    bool isShort,
    double available,
  ) {
    final labels = args.labels;
    final strings = context.resources.strings;
    final extras = args.extrasPrice > 0
        ? BreakdownLineItem(
            label: '${args.extrasLabel ?? strings.extraSkills} '
                '(x${args.extrasCount})',
            amount: _money(args.extrasPrice),
          )
        : null;

    if (isShort) {
      // Fee and what the wallet already covers (design p232).
      return [
        BreakdownLineItem(label: labels.feeLabel, amount: _money(args.fee)),
        if (extras != null) extras,
        BreakdownLineItem(
          label: strings.availableLabel,
          amount: _money(available),
        ),
      ];
    }

    if (args.isFirst && !args.showPromo) {
      // Nothing to charge and no promo to explain — just the total row.
      return [if (extras != null) extras];
    }

    if (args.isFirst) {
      // Fee struck through and cancelled by the promo (design p194).
      return [
        BreakdownLineItem(
          label: labels.feeLabel,
          amount: _money(args.fee),
          strikethrough: true,
        ),
        BreakdownLineItem(
          label: labels.promoLabel,
          amount: '-${_money(args.fee)}',
          discount: true,
        ),
        if (extras != null) extras,
      ];
    }

    return [
      BreakdownLineItem(label: labels.feeLabel, amount: _money(args.fee)),
      if (extras != null) extras,
    ];
  }

  /// Rounds "what's missing plus one more post" up to the nearest \$5, matching
  /// the design's "\$5 covers this post plus another with change".
  static String _suggestedTopUp(double fee, double shortfall) {
    final rounded = ((shortfall + fee) / 5).ceil() * 5;
    return '\$${math.max(5, rounded)}';
  }
}

/// "Posting this job costs $2. You're $1.50 short…" — the amount in red.
class _ShortfallNote extends StatelessWidget {
  const _ShortfallNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;

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
