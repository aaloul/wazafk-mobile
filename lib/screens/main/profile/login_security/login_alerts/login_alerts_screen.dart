import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../notification_settings/components/notif_toggle_card.dart';
import 'login_alerts_controller.dart';

class LoginAlertsScreen extends StatelessWidget {
  const LoginAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginAlertsController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(hasBack: true, title: strings.loginAlerts),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Obx(() => NotifToggleCard(
                  title: strings.loginAlerts,
                  children: [
                    NotifToggleRow(
                      label: strings.pushNotifications,
                      value: controller.pushEnabled.value,
                      onChanged: controller.setPush,
                    ),
                    NotifToggleRow(
                      label: strings.emailNotifications,
                      value: controller.emailEnabled.value,
                      onChanged: controller.setEmail,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
