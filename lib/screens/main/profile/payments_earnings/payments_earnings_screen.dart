import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

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
          children: [TopHeader(hasBack: true, title: 'Payments & Earnings')],
        ),
      ),
    );
  }
}
