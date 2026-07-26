import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class BreakdownLineItem {
  const BreakdownLineItem({
    required this.label,
    required this.amount,
    this.strikethrough = false,
    this.discount = false,
  });
  final String label;
  final String amount;
  final bool strikethrough;
  final bool discount;
}

/// Cost breakdown card with line items and a "Total today" footer pill.
class BreakdownCard extends StatelessWidget {
  const BreakdownCard({
    super.key,
    required this.items,
    required this.totalLabel,
    required this.totalValue,
    this.totalIsFree = false,
  });

  final List<BreakdownLineItem> items;
  final String totalLabel;
  final String totalValue;
  final bool totalIsFree;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
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
          for (int i = 0; i < items.length; i++) ...[
            _Row(item: items[i]),
            if (i != items.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          Container(height: 1, color: colors.colorGrey25),
          const SizedBox(height: 14),
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
                    text: totalLabel,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorPrimary,
                  ),
                ),
                PrimaryText(
                  text: totalValue,
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
  const _Row({required this.item});
  final BreakdownLineItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final valueColor =
        item.discount ? colors.colorPrimary : colors.colorBlack;
    return Row(
      children: [
        Expanded(
          child: PrimaryText(
            text: item.label,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            textColor: colors.colorBlack,
          ),
        ),
        Text(
          item.amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: item.strikethrough ? colors.colorGrey : valueColor,
            decoration: item.strikethrough
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: colors.colorGrey,
          ),
        ),
      ],
    );
  }
}
