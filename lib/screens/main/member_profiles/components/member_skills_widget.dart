import 'package:flutter/material.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';

class MemberSkillsWidget extends StatelessWidget {
  const MemberSkillsWidget({super.key, required this.skills});

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skills Section
          PrimaryText(
            text: context.resources.strings.skills,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            textColor: context.resources.color.colorGrey,
          ),
          SizedBox(height: 8),

          // Check if we have skills
          Builder(
            builder: (context) {
              if (skills.isEmpty) {
                return PrimaryText(
                  text: context.resources.strings.noSkillsAddedYet,
                  fontSize: 14,
                  textColor: context.resources.color.colorGrey,
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: context.resources.color.colorGrey4,
                      ),
                    ),
                    child: PrimaryText(
                      text: skill.name ?? 'Unknown',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
