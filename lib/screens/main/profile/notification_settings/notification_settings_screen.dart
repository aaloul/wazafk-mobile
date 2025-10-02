import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/profile/notification_settings/components/notification_settings_group.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'notification_settings_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationSettingsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
              hasBack: true,
              title: 'Notifications Option',
            ),
            SizedBox(height: 8,),

            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [


                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.settingsGroups.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, groupIndex) {
                          final group = controller.settingsGroups[groupIndex];
                          return NotificationSettingsGroup(
                              settingsGroup: group);
                        },
                      ),

                      SizedBox(height: 16,),

                    ],
                  ),
                )
            ),

          ],
        ),
      ),
    );
  }
}
