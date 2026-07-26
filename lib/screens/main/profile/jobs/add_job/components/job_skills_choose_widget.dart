import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

/// "Skills" pills at the top of the Job Details card (design p185).
///
/// Shows the skills of the picked category; before a category is picked it
/// falls back to the full skills list so the row is never empty.
class JobSkillsChooseWidget extends StatelessWidget {
  const JobSkillsChooseWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();
    final homeController = Get.find<HomeController>();
    final colors = context.resources.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: context.resources.strings.skills,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textColor: colors.colorGrey26,
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoadingSkills.value) {
            return Center(child: ProgressBar());
          }

          final skills = controller.categorySkills.isNotEmpty
              ? controller.categorySkills.toList()
              : homeController.skills.toList();

          if (skills.isEmpty) return const SizedBox.shrink();

          final selectedHashcodes =
              controller.selectedSkills.map((s) => s.hashcode).toSet();

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (skill) => _SkillPill(
                    skill: skill,
                    selected: selectedHashcodes.contains(skill.hashcode),
                    onTap: () {
                      if (enabled) controller.toggleSkill(skill);
                    },
                  ),
                )
                .toList(),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Pill-shaped skill chip — white with a grey outline, blue outline + blue
/// label with a soft blue glow when picked (design p185).
class _SkillPill extends StatelessWidget {
  const _SkillPill({
    required this.skill,
    required this.selected,
    required this.onTap,
  });

  final Skill skill;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? colors.colorPrimary : colors.colorGrey29,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.colorPrimary.withAlpha(60),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: PrimaryText(
          text: skill.name ?? '',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          textColor: selected ? colors.colorPrimary : colors.colorGrey26,
        ),
      ),
    );
  }
}
