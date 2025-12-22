import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'working_days_controller.dart';

class WorkingDaysScreen extends StatelessWidget {
  const WorkingDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkingDaysController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
                hasBack: true, title: context.resources.strings.workingDays)
          ],
        ),
      ),
    );
  }
}
