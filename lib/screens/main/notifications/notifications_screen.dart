import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import 'components/notification_tabs_widget.dart';
import 'components/notifications_list_widget.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        GestureDetector(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: RotatedBox(
                            quarterTurns: Utils().isRTL() ? 2 : 0,
                            child: Image.asset(AppIcons.back3, width: 32),
                          ),
                        ),

                        PrimaryText(
                          text: Resources.of(context).strings.notifications,
                          textColor: context.resources.color.colorBlack4,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),


                        SizedBox()
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  Obx(
                    () => NotificationTabsWidget(
                      tabs: controller.tabs,
                      onSelect: (tab) => controller.changeTab(tab),
                      selectedTab: controller.selectedTab.value,
                      margin: 10,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(child: NotificationsListWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
