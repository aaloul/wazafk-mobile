import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'way_of_payment_controller.dart';

class WayOfPaymentScreen extends StatelessWidget {
  const WayOfPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WayOfPaymentController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
                hasBack: true, title: context.resources.strings.wayOfPayment)
          ],
        ),
      ),
    );
  }
}
