import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/profile/login_security/saved_login/saved_login_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SavedLoginScreen extends StatelessWidget {
  const SavedLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedLoginController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Saved Login'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
