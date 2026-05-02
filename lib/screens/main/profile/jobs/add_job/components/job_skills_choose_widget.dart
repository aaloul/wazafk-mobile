import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

class JobSkillsChooseWidget extends StatelessWidget {
  const JobSkillsChooseWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Obx(() {
      if (controller.isLoadingSkills.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: "${context.resources.strings.skills} *",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textColor: context.resources.color.colorGrey26,
            ),
            SizedBox(height: 8),
            Center(child: ProgressBar()),
            SizedBox(height: 12),
          ],
        );
      }

      if (controller.categorySkills.isEmpty) return SizedBox.shrink();

      final selectedHashcodes =
          controller.selectedSkills.map((s) => s.hashcode).toSet();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: "${context.resources.strings.skills}",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            textColor: context.resources.color.colorGrey26,
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.categorySkills.map((skill) {
              final isSelected = selectedHashcodes.contains(skill.hashcode);
              return GestureDetector(
                onTap: () {
                  if (enabled) controller.toggleSkill(skill);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.resources.color.colorPrimary.withAlpha(16)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? context.resources.color.colorPrimary
                          : context.resources.color.colorGrey29,
                      width: 1,
                    ),
                  ),
                  child: PrimaryText(
                    text: skill.name ?? '',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    textColor: isSelected
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey26,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
        ],
      );
    });
  }
}
