import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/WalletTransactionsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'wallet_history_controller.dart';

class WalletHistoryScreen extends StatelessWidget {
  const WalletHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletHistoryController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.walletHistory),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: ProgressBar());
                }
                if (controller.transactions.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: strings.noTransactions,
                      fontSize: 14,
                      textColor: colors.colorGrey,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: controller.transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      _TxRow(tx: controller.transactions[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.tx});

  final Transaction tx;

  /// Wallet transaction direction. Backend uses `type` = 'CR' (credit / cash
  /// in, e.g. job payment received) or 'DR' (debit / cash out, e.g. wallet
  /// charge). Treat anything matching credit patterns as inbound.
  bool get _isCredit {
    final t = (tx.type ?? '').toUpperCase();
    if (t == 'CR' || t == 'CREDIT' || t == 'IN') return true;
    if (t == 'DR' || t == 'DEBIT' || t == 'OUT') return false;
    final action = (tx.action ?? '').toUpperCase();
    return action.contains('RECEIVE') || action.contains('CREDIT');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final isCredit = _isCredit;
    final amountColor =
        isCredit ? colors.colorPrimary : colors.colorRed2;
    final arrowIcon =
        isCredit ? AppIcons.walletCreditArrow : AppIcons.walletDebitArrow;
    final title = tx.details?.isNotEmpty == true
        ? tx.details!
        : tx.action ?? tx.reason ?? '-';
    final subtitle = tx.createdAt != null
        ? DateFormat('d MMM yyyy').format(tx.createdAt!)
        : tx.code ?? '';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.toNamed(
        RouteConstant.paymentReceiptScreen,
        arguments: tx,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorBlack,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                PrimaryText(
                  text: subtitle,
                  fontSize: 12,
                  textColor: colors.colorGrey,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(arrowIcon, width: 18, color: amountColor),
              const SizedBox(height: 6),
              PrimaryText(
                text: '\$ ${tx.amount ?? '0.00'}',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                textColor: amountColor,
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
