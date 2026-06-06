import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

class PaymentMethodCard {
  const PaymentMethodCard({
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

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  // Backend has wallet/paymentProfiles but the schema (bank account / payout
  // routing) doesn't match Figma's card-list layout. Static seed for now;
  // swap to a controller-driven Obx list once a card-listing endpoint exists.
  static const _seed = <PaymentMethodCard>[
    PaymentMethodCard(
      brandIcon: AppIcons.brandMaster,
      name: 'Master',
      lastDigits: '0000',
      expires: '01/2027',
    ),
    PaymentMethodCard(
      brandIcon: AppIcons.brandOmt,
      name: 'Omt',
      lastDigits: '0000',
      expires: '01/2027',
    ),
    PaymentMethodCard(
      brandIcon: AppIcons.brandVisa,
      name: 'Visa',
      lastDigits: '0000',
      expires: '01/2027',
    ),
    PaymentMethodCard(
      brandIcon: AppIcons.brandWhish,
      name: 'Whish',
      lastDigits: '0000',
      expires: '01/2027',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(hasBack: true, title: strings.payments),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: PrimaryText(
                  text: strings.paymentMethods,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorBlack,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AddCardButton(
                onTap: () => Get.toNamed(RouteConstant.addCardScreen),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.colorWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        for (int i = 0; i < _seed.length; i++) ...[
                          _PaymentMethodRow(
                            card: _seed[i],
                            isFirst: i == 0,
                            isLast: i == _seed.length - 1,
                          ),
                          if (i != _seed.length - 1)
                            Container(
                              height: 1,
                              color: colors.colorGrey4,
                              margin: const EdgeInsetsDirectional.only(
                                  start: 64),
                            ),
                        ],
                      ],
                    ),
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

class _AddCardButton extends StatelessWidget {
  const _AddCardButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppIcons.addCardPlus, width: 22, height: 22),
            const SizedBox(width: 8),
            PrimaryText(
              text: strings.addCard,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              textColor: colors.colorBlack,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({
    required this.card,
    required this.isFirst,
    required this.isLast,
  });

  final PaymentMethodCard card;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      color: colors.colorWhite,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 28,
            child: Image.asset(card.brandIcon, fit: BoxFit.contain),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: card.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.colorBlack,
                ),
                const SizedBox(height: 2),
                PrimaryText(
                  text: '${strings.endingWith} ${card.lastDigits}',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: colors.colorGrey,
                ),
              ],
            ),
          ),
          PrimaryText(
            text: '${strings.expires} ${card.expires}',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textColor: colors.colorGrey,
          ),
          const SizedBox(width: 8),
          RotatedBox(
            quarterTurns: Utils().isRTL() ? 2 : 0,
            child: Image.asset(
              AppIcons.arrowRight2,
              width: 14,
              color: colors.colorGrey,
            ),
          ),
        ],
      ),
    );
  }
}
