import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/profile/packages/add_package/add_package_controller.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/working_hours_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class PackageWorkingHoursBottomSheet extends StatelessWidget {
  const PackageWorkingHoursBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PackageWorkingHoursBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPackageController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.resources.color.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with drag indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorGrey8,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 48),
                    PrimaryText(
                      text: 'Working Hours',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorPrimary,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: context.resources.color.colorGrey,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: context.resources.color.colorGrey8),

          SizedBox(height: 16),

          // Working hours list
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

          // Save button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: context.resources.color.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                title: Resources.of(context).strings.saveWorkingHours,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
