import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/model/WalletTransactionsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../components/primary_chooser.dart';
import '../../../../../components/primary_text.dart';
import '../payments_earnings_controller.dart';

class RecentTransactionsWidget extends StatefulWidget {
  const RecentTransactionsWidget({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  State<RecentTransactionsWidget> createState() =>
      _RecentTransactionsWidgetState();
}

class _RecentTransactionsWidgetState extends State<RecentTransactionsWidget> {
  String selectedSortBy = '';

  @override
  void initState() {
    super.initState();
    // Initialize with translated default value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedSortBy = context.resources.strings.dateDescending;
      });
    });
  }

  String _mapSortByToApiValue(BuildContext context, String displayValue) {
    final strings = context.resources.strings;
    if (displayValue == strings.dateAscending) {
      return 'date_asc';
    } else if (displayValue == strings.dateDescending) {
      return 'date_desc';
    } else if (displayValue == strings.amountAscending) {
      return 'amount_asc';
    } else if (displayValue == strings.amountDescending) {
      return 'amount_desc';
    } else {
      return 'date_desc';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentsEarningsController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.recentTransactions,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            textColor: context.resources.color.colorGrey,
          ),
          SizedBox(height: 6),
          PrimaryChooser(
            label: '',
            text: context.resources.strings.sortBy,
            selected: selectedSortBy.isEmpty ? context.resources.strings.dateDescending : selectedSortBy,
            withArrow: true,
            isMandatory: false,
            isMultiSelect: false,
            list: [
              context.resources.strings.dateAscending,
              context.resources.strings.dateDescending,
              context.resources.strings.amountAscending,
              context.resources.strings.amountDescending,
            ],
            onSelect: (value) {
              setState(() {
                selectedSortBy = value;
              });
              controller.updateSortBy(_mapSortByToApiValue(context, value));
            },
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: PrimaryText(
                  text: context.resources.strings.date,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textColor: context.resources.color.colorGrey3,
                ),
              ),
              Expanded(
                flex: 1,
                child: PrimaryText(
                  text: context.resources.strings.amount,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textColor: context.resources.color.colorGrey3,
                ),
              ),
              Expanded(
                flex: 1,
                child: PrimaryText(
                  text: context.resources.strings.reason,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textColor: context.resources.color.colorGrey3,
                ),
              ),
            ],
          ),

          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.transactions.length,
            itemBuilder: (BuildContext context, int index) {
              return RecentTransactionItem(
                transaction: widget.transactions[index],
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecentTransactionItem extends StatelessWidget {
  const RecentTransactionItem({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isOutgoing = transaction.type?.toLowerCase() == 'o';
    final amountText = transaction.amount ?? context.resources.strings.notAvailable;
    final displayAmount = isOutgoing ? "-$amountText" : amountText;
    final amountColor = isOutgoing
        ? context.resources.color.colorRed
        : context.resources.color.colorBlack2;

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 5),
          height: 1,
          color: HexColor("#353C82").withOpacity(.1),
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: PrimaryText(
                text: DateFormat('dd-MM-yyyy').format(transaction.createdAt!),
                fontWeight: FontWeight.w500,
                fontSize: 13,
                textColor: context.resources.color.colorBlack2,
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 1,
              child: PrimaryText(
                text: "$displayAmount USD",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                textColor: amountColor,
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 1,
              child: PrimaryText(
                text:
                    transaction.reason ??
                    context.resources.strings.notAvailable,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                textColor: context.resources.color.colorBlack2,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
