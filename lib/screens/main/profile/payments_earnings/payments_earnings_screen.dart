import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../components/tabs_widget.dart';
import 'components/recent_transactions_widget.dart';
import 'payments_earnings_controller.dart';

class PaymentsEarningsScreen extends StatelessWidget {
  const PaymentsEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentsEarningsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeader(hasBack: true, title: 'Payments & Earnings'),

            Obx(
                  () =>
                  TabsWidget(
                    tabs: ['Payment Overview', 'Earnings Overview'],
                    onSelect: (tab) {
                      controller.selectedTab.value = tab;
                      controller.fetchWalletTransactions();
                    },
                    selectedTab: controller.selectedTab.value,
                  ),
            ),
            SizedBox(height: 16,),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: HexColor("#CDE9EE")
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            PrimaryText(
                              text: context.resources.strings.totalTransactions,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              textColor: context.resources.color.colorGrey,),
                            SizedBox(height: 4,),
                            Obx(() =>
                                PrimaryText(
                                    text: "${controller.totalTransactions
                                        .value}",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    textColor: context.resources.color
                                        .colorGrey)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.resources.color.colorGrey17
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            PrimaryText(
                              text: context.resources.strings.totalPayout,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              textColor: context.resources.color.colorGrey,),
                            SizedBox(height: 4,),
                            Obx(() =>
                                PrimaryText(text: controller.totalPayout.value,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    textColor: context.resources.color
                                        .colorGrey)),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Obx(() =>
            controller.isLoading.value
                ? Center(child: ProgressBar())
                : RecentTransactionsWidget(
                transactions: controller.transactions.value))
          ],
        ),
        ),
    );
  }
}
