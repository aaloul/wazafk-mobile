import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'share_app_controller.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShareAppController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(children: [TopHeader(hasBack: true, title: 'Share App')]),
      ),
    );
  }
}
