import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_service_controller.dart';

class SkillsChooseWidget extends StatelessWidget {
  const SkillsChooseWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();

    return Obx(() {
      if (controller.isLoadingSkills.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: context.resources.strings.skills,
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

      if (controller.availableSkills.isEmpty) return SizedBox.shrink();

      final selectedHashcodes =
          controller.selectedSkills.map((s) => s.hashcode).toSet();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.skills,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            textColor: context.resources.color.colorGrey26,
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.availableSkills.map((skill) {
              final isSelected = selectedHashcodes.contains(skill.hashcode);
              return GestureDetector(
                onTap: () {
                  if (enabled) controller.toggleSkillSelection(skill);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.resources.color.colorPrimary.withAlpha(16)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? context.resources.color.colorPrimary
                          : context.resources.color.colorGrey25,
                      width: 1,
                    ),
                  ),
                  child: PrimaryText(
                    text: skill.name ?? '',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    textColor: isSelected
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorBlack4,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
