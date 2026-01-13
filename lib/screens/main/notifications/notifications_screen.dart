import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'components/notification_tabs_widget.dart';
import 'components/notifications_list_widget.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(title: Resources.of(context).strings.notifications),
            SizedBox(height: 8),

            Obx(
              () => NotificationTabsWidget(
                tabs: controller.tabs,
                selectedTab: controller.selectedTab.value,
                onSelect: (tab) => controller.changeTab(tab),
              ),
            ),

            SizedBox(height: 8),

            Expanded(child: NotificationsListWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
