import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/add_service_controller.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/working_hours_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SelectServiceWorkingHoursScreen extends StatelessWidget {
  const SelectServiceWorkingHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Working Hours'),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.workingHours.length,
                        itemBuilder: (context, index) {
                          final workingDay = controller.workingHours[index];
                          return WorkingHoursItem(
                            workingDay: workingDay,
                            index: index,
                            onToggle: (value) {
                              controller.toggleDayEnabled(index, value);
                            },
                            onStartTimeSelect: (time) {
                              controller.updateStartTime(index, time);
                            },
                            onEndTimeSelect: (time) {
                              controller.updateEndTime(index, time);
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: PrimaryButton(
                title: 'Save Working Hours',
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
