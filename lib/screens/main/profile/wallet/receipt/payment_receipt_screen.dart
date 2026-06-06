import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/WalletTransactionsResponse.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

/// Figma p61 (Receipt — incoming) / p116 (Invoice — outgoing).
/// Reuses the same layout, flips title + "from/to" labels + bottom-pill copy
/// based on the transaction's direction.
class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key});

  bool _isCredit(Transaction tx) {
    final t = (tx.type ?? '').toUpperCase();
    if (t == 'CR' || t == 'CREDIT' || t == 'IN') return true;
    if (t == 'DR' || t == 'DEBIT' || t == 'OUT') return false;
    final action = (tx.action ?? '').toUpperCase();
    if (action.contains('RECEIVE') || action.contains('CREDIT')) return true;
    if (action.contains('CHARGE') || action.contains('PAY') ||
        action.contains('DEBIT')) {
      return false;
    }
    // Fallback: if the amount itself has a sign, trust it. Negative ⇒ debit.
    final amt = double.tryParse(tx.amount ?? '');
    if (amt != null && amt < 0) return false;
    return true; // safer default: render as receipt (incoming).
  }

  @override
  Widget build(BuildContext context) {
    final tx = Get.arguments as Transaction;
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final isCredit = _isCredit(tx);
    final headerTitle = isCredit
        ? strings.paymentReceiptTitle
        : strings.paymentInvoiceTitle;

    final amount = double.tryParse(tx.amount ?? '0') ?? 0;
    final fee = amount * 0.10;
    final net = amount - fee;
    final dateStr = tx.createdAt != null
        ? DateFormat('d MMM yyyy').format(tx.createdAt!)
        : '-';

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            _ReceiptHeader(title: headerTitle),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _JobHeaderCard(
                      title: tx.details ??
                          tx.action ??
                          tx.reason ??
                          tx.code ??
                          '-',
                      completedLabel:
                          '${strings.jobCompletedOn} $dateStr',
                      totalLabel: '${strings.total} \$ ${amount.toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 16),
                    PrimaryText(
                      text: isCredit
                          ? strings.paymentFromLabel
                          : strings.paymentToLabel,
                      fontSize: 12,
                      textColor: colors.colorGrey,
                    ),
                    const SizedBox(height: 8),
                    _CounterpartyCard(
                      name: tx.target ?? '-',
                      rating: '4.5',
                    ),
                    const SizedBox(height: 12),
                    _DetailsCard(
                      idLabel: isCredit
                          ? strings.receiptLabel
                          : strings.invoiceLabel,
                      idValue: tx.code ?? '-',
                      transactionId: tx.hashcode ?? '-',
                      escrowDate: dateStr,
                      releasedDate: dateStr,
                      jobAmount: '\$${amount.toStringAsFixed(2)}',
                      fee: '\$${fee.toStringAsFixed(2)}',
                      footerLabel: isCredit ? strings.received : strings.paid,
                      footerValue: isCredit
                          ? '\$${net.toStringAsFixed(2)}'
                          : '\$${amount.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row-based header dedicated to this screen. The default `TopHeader` centres
/// its title inside a Stack with the back button on a Positioned edge — on
/// narrow widths the centred PrimaryText can be clipped to "" because the
/// Stack gives it no explicit width. A Row with Expanded text guarantees the
/// title always renders.
class _ReceiptHeader extends StatelessWidget {
  const _ReceiptHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      height: 56,
      color: colors.colorWhite,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.back(),
            child: RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(AppIcons.back3, width: 36),
            ),
          ),
          Expanded(
            child: PrimaryText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              textColor: colors.colorBlack,
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _JobHeaderCard extends StatelessWidget {
  const _JobHeaderCard({
    required this.title,
    required this.completedLabel,
    required this.totalLabel,
  });

  final String title;
  final String completedLabel;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colors.colorPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: colors.colorWhite,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: colors.colorWhite.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(
                AppIcons.checkCircle,
                width: 14,
                color: colors.colorWhite,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: PrimaryText(
                  text: completedLabel,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: colors.colorWhite,
                ),
              ),
              PrimaryText(
                text: totalLabel,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                textColor: colors.colorWhite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterpartyCard extends StatelessWidget {
  const _CounterpartyCard({required this.name, required this.rating});

  final String name;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          ClipOval(
            child: SizedBox(
              width: 36,
              height: 36,
              child: Prefs.getAvatar.isNotEmpty
                  ? PrimaryNetworkImage(
                      url: Prefs.getAvatar,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(AppIcons.placeholder, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          PrimaryText(
            text: name,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(width: 8),
          Image.asset(
            AppIcons.star,
            width: 13,
            color: const Color(0xFFFFB800),
          ),
          const SizedBox(width: 3),
          PrimaryText(
            text: rating,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.colorBlack,
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.idLabel,
    required this.idValue,
    required this.transactionId,
    required this.escrowDate,
    required this.releasedDate,
    required this.jobAmount,
    required this.fee,
    required this.footerLabel,
    required this.footerValue,
  });

  final String idLabel;
  final String idValue;
  final String transactionId;
  final String escrowDate;
  final String releasedDate;
  final String jobAmount;
  final String fee;
  final String footerLabel;
  final String footerValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      child: Column(
        children: [
          _Row(label: idLabel, value: idValue),
          const SizedBox(height: 8),
          _Row(label: strings.transactionIdLabel, value: transactionId),
          _Divider(),
          _Row(label: strings.escrowDeposit, value: escrowDate),
          const SizedBox(height: 8),
          _Row(label: strings.released, value: releasedDate),
          _Divider(),
          _Row(label: strings.jobAmount, value: jobAmount),
          const SizedBox(height: 8),
          _Row(label: strings.wazafkFee, value: fee),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: colors.colorPrimaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryText(
                    text: footerLabel,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorPrimary,
                  ),
                ),
                PrimaryText(
                  text: footerValue,
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

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
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
          maxLines: 2,
          fontWeight: FontWeight.w500,
          textColor: colors.colorBlack,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: context.resources.color.colorGrey4,
    );
  }
}
