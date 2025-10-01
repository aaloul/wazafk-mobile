import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class HomeStatisticsWidget extends StatelessWidget {
  const HomeStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: context.resources.color.colorPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor("#00AEC81A"), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              StatisticsItem(
                title: 'Total Earnings',
                value: '\$834.12',
                textIcon: "\$",
                icon: "",
              ),
              SizedBox(width: 10),
              StatisticsItem(
                title: 'Active Jobs',
                value: '8',
                icon: AppIcons.time,
              ),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: [
              StatisticsItem(
                title: 'Completed',
                value: '12',
                icon: AppIcons.completed,
              ),
              SizedBox(width: 10),
              StatisticsItem(
                title: 'Success Rate',
                value: '96%',
                icon: AppIcons.chart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatisticsItem extends StatelessWidget {
  const StatisticsItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.textIcon,
  });

  final String title;
  final String value;
  final String icon;
  final String? textIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryText(
                    text: title,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: context.resources.color.colorGrey8,
                  ),
                ),

                if (textIcon == null)
                  Image.asset(
                    icon,
                    height: 24,
                    width: 24,
                    fit: BoxFit.fitHeight,
                  ),
                if (textIcon != null)
                  PrimaryText(
                    text: "\$",
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    textColor: context.resources.color.colorGrey8,
                  ),
              ],
            ),
            SizedBox(height: 4),

            PrimaryText(
              text: value,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorGrey8,
            ),
          ],
        ),
      ),
    );
  }
}
