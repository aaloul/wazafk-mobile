import 'package:flutter/material.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';

class MemberSkillsWidget extends StatelessWidget {
  const MemberSkillsWidget({super.key, required this.skills});

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.skills,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            textColor: context.resources.color.colorBlack,
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.resources.color.colorPrimaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: PrimaryText(
                  text: skill.name ?? '',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
