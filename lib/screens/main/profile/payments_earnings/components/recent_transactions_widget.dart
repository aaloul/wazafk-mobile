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
  String selectedSortBy = 'Date Descending';

  String _mapSortByToApiValue(String displayValue) {
    switch (displayValue) {
      case 'Date Ascending':
        return 'date_asc';
      case 'Date Descending':
        return 'date_desc';
      case 'Amount Ascending':
        return 'amount_asc';
      case 'Amount Descending':
        return 'amount_desc';
      default:
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
            text: "Recent Transactions",
            fontWeight: FontWeight.w900,
            fontSize: 16,
            textColor: context.resources.color.colorGrey,
          ),
          SizedBox(height: 6),
          PrimaryChooser(
            label: '',
            text: 'Sort By',
            selected: selectedSortBy,
            withArrow: true,
            isMandatory: false,
            isMultiSelect: false,
            list: [
              'Date Ascending',
              'Date Descending',
              'Amount Ascending',
              'Amount Descending',
            ],
            onSelect: (value) {
              setState(() {
                selectedSortBy = value;
              });
              controller.updateSortBy(_mapSortByToApiValue(value));
            },
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: PrimaryText(
                  text: "Date",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textColor: context.resources.color.colorGrey3,
                ),
              ),
              Expanded(
                flex: 1,
                child: PrimaryText(
                  text: "Amount",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textColor: context.resources.color.colorGrey3,
                ),
              ),
              Expanded(
                flex: 1,
                child: PrimaryText(
                  text: "Reason",
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
                text: "${transaction.amount ?? "N/A"} USD",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                textColor: context.resources.color.colorBlack2,
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 1,
              child: PrimaryText(
                text: transaction.reason ?? "N/A",
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
