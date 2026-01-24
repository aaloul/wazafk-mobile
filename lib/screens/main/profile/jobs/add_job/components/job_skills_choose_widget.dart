import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

class JobSkillsChooseWidget extends StatelessWidget {
  const JobSkillsChooseWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: "${context.resources.strings.skills} *",
          fontWeight: FontWeight.w900,
          fontSize: 16,
          textColor: context.resources.color.colorGrey,
        ),

        SizedBox(height: 8),
        PrimaryText(
          text: context.resources.strings.skillsAdditionNote,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textColor: context.resources.color.colorGrey3,
        ),

        SizedBox(height: 12),

        Obx(() {
          if (controller.selectedSkills.isEmpty) {
            if (!enabled) {
              return PrimaryText(
                text: context.resources.strings.noSkillsSelected,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: context.resources.color.colorGrey,
              );
            }
            return GestureDetector(
              onTap: () {
                SheetHelper.showSkillsSheet(
                  context,
                  selectedSkills: controller.selectedSkills,
                  onSkillsSelected: (skills) {
                    controller.selectedSkills.value = skills;
                  },
                  availableSkills: controller.categorySkills,
                  isLoadingSkills: controller.isLoadingSkills.value,
                );
              },
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(16),
                  color: context.resources.color.colorGrey2,
                  strokeWidth: 1,
                  dashPattern: [3, 3],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 14,
                        color: context.resources.color.colorGrey,
                      ),
                      PrimaryText(
                        text: context.resources.strings.add,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...controller.selectedSkills.map(
                (skill) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PrimaryText(
                        text: skill.name ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorWhite,
                      ),
                      if (enabled) ...[
                        SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            controller.toggleSkill(skill);
                          },
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: context.resources.color.colorWhite,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (enabled)
                GestureDetector(
                  onTap: () {
                    SheetHelper.showSkillsSheet(
                      context,
                      selectedSkills: controller.selectedSkills,
                      onSkillsSelected: (skills) {
                        controller.selectedSkills.value = skills;
                      },
                      availableSkills: controller.categorySkills,
                      isLoadingSkills: controller.isLoadingSkills.value,
                    );
                  },
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(16),
                      color: context.resources.color.colorGrey2,
                      strokeWidth: 1,
                      dashPattern: [3, 3],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 14,
                            color: context.resources.color.colorGrey,
                          ),
                          PrimaryText(
                            text: context.resources.strings.add,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: context.resources.color.colorGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
