import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SkillsSheet extends StatefulWidget {
  final List<Skill> selectedSkills;
  final Function(List<Skill>) onSkillsSelected;
  final List<Skill>? availableSkills;
  final bool isLoadingSkills;

  const SkillsSheet({
    super.key,
    required this.selectedSkills,
    required this.onSkillsSelected,
    this.availableSkills,
    this.isLoadingSkills = false,
  });

  @override
  State<SkillsSheet> createState() => _SkillsSheetState();
}

class _SkillsSheetState extends State<SkillsSheet> {
  late List<Skill> tempSelectedSkills;
  HomeController? homeController;

  @override
  void initState() {
    super.initState();
    tempSelectedSkills = List.from(widget.selectedSkills);
    // Only try to find HomeController if availableSkills is not provided
    if (widget.availableSkills == null) {
      try {
        homeController = Get.find<HomeController>();
      } catch (e) {
        // HomeController not found, will use empty list
      }
    }
  }

  bool isSkillSelected(Skill skill) {
    return tempSelectedSkills.any((s) => s.hashcode == skill.hashcode);
  }

  void toggleSkillSelection(Skill skill) {
    setState(() {
      if (isSkillSelected(skill)) {
        tempSelectedSkills.removeWhere((s) => s.hashcode == skill.hashcode);
      } else {
        tempSelectedSkills.add(skill);
      }
    });
  }

  Widget _buildSkillsList(List<Skill> skills, bool isLoading,
      BuildContext context) {
    if (isLoading) {
      return Center(
        child: ProgressBar(
          color: context.resources.color.colorPrimary,
        ),
      );
    }

    if (skills.isEmpty) {
      return Center(
        child: PrimaryText(
          text: 'No skills available for this category',
          textColor: context.resources.color.colorGrey8,
        ),
      );
    }

    return SingleChildScrollView(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills.map((skill) {
          final isSelected = isSkillSelected(skill);
          return GestureDetector(
            onTap: () => toggleSkillSelection(skill),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.resources.color.colorPrimary
                    : context.resources.color.colorWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey2,
                  width: 1,
                ),
              ),
              child: PrimaryText(
                text: skill.name ?? '',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: isSelected
                    ? context.resources.color.colorWhite
                    : context.resources.color.colorGrey3,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: context.resources.color.background2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryText(
                  text: "Select Skills",
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorGrey,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: context.resources.color.colorGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
                child: _buildSkillsList(
                    widget.availableSkills!, widget.isLoadingSkills, context)
            ),
            SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: 'Apply',
                    onPressed: () {
                      widget.onSkillsSelected(tempSelectedSkills);
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
