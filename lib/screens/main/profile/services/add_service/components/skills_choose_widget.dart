import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../../components/primary_text.dart';
import '../../../../../../components/sheets/sheets_helper.dart';
import '../add_service_controller.dart' show AddServiceController;

class SkillsChooseWidget extends StatelessWidget {
  SkillsChooseWidget({super.key});

  final controller = Get.put(AddServiceController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: "Skills *",
          fontWeight: FontWeight.w900,
          fontSize: 16,
          textColor: context.resources.color.colorGrey,
        ),

        SizedBox(height: 8),
        PrimaryText(
          text: "You can add 2 the rest will be charged.",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textColor: context.resources.color.colorGrey3,
        ),

        SizedBox(height: 12),

        Obx(() {
          if (controller.selectedSkills.isEmpty) {
            return GestureDetector(
              onTap: () {
                SheetHelper.showSkillsSheet(
                  context,
                  selectedSkills: controller.selectedSkills,
                  onSkillsSelected: (skills) {
                    controller.selectedSkills.value = skills;
                  },
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
                        text: 'Add',
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
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          controller.toggleSkillSelection(skill);
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: context.resources.color.colorWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  SheetHelper.showSkillsSheet(
                    context,
                    selectedSkills: controller.selectedSkills,
                    onSkillsSelected: (skills) {
                      controller.selectedSkills.value = skills;
                    },
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
                          text: 'Add',
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
