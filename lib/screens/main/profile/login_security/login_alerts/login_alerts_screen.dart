import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'login_alerts_controller.dart';

class LoginAlertsScreen extends StatelessWidget {
  const LoginAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginAlertsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Login Alerts'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
