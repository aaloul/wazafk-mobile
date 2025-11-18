import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'all_employer_data_controller.dart';
import 'components/employer_data_list_widget.dart';

class AllEmployerDataScreen extends StatelessWidget {
  const AllEmployerDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllEmployerDataController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(title: "Freelancers & Services"),
            SizedBox(height: 8),

            // Obx(() => TabsWidget(
            //   tabs: controller.tabs,
            //   selectedTab: controller.selectedTab.value,
            //   onSelect: (tab) => controller.changeTab(tab),
            // )),

            // SizedBox(height: 8),
            Expanded(child: EmployerDataListWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
