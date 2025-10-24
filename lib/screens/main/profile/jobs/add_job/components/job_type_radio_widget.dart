import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

class JobTypeRadioWidget extends StatelessWidget {
  const JobTypeRadioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: "Job Type *",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textColor: context.resources.color.colorGrey3,
        ),
        SizedBox(height: 12),
        Obx(
          () => Column(
            children: [
              _buildJobTypeRadio(context, controller, 'Onsite'),
              SizedBox(height: 8),
              _buildJobTypeRadio(context, controller, 'Remote'),
              SizedBox(height: 8),
              _buildJobTypeRadio(context, controller, 'Hybrid'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeRadio(
    BuildContext context,
    AddJobController controller,
    String jobType,
  ) {
    final isSelected = controller.selectedJobType.value == jobType;

    return GestureDetector(
      onTap: () {
        controller.selectJobType(jobType);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.resources.color.colorGreen4
              : context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.resources.color.colorGrey4
                : context.resources.color.colorGrey4,
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryText(
                text: jobType,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                textColor: context.resources.color.colorGrey8,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey2,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.resources.color.colorPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
