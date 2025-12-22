import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'privacy_sharing_controller.dart';

class PrivacySharingScreen extends StatelessWidget {
  const PrivacySharingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrivacySharingController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true,
                title: context.resources.strings.privacyAndSharing)
          ],
        ),
      ),
    );
  }
}
