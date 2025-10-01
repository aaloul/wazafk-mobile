import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'give_feedback_controller.dart';

class GiveFeedbackScreen extends StatelessWidget {
  const GiveFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GiveFeedbackController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [TopHeader(hasBack: true, title: 'Give Us Feedback')],
        ),
      ),
    );
  }
}
