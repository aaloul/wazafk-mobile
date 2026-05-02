import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

class JobTypeRadioWidget extends StatelessWidget {
  const JobTypeRadioWidget({super.key, this.enabled = true});

  final bool enabled;

  static const _types = ['Onsite', 'Remote', 'Hybrid'];

  String _label(BuildContext context, String type) {
    switch (type) {
      case 'Remote':  return context.resources.strings.remote;
      case 'Hybrid':  return context.resources.strings.hybrid;
      case 'Onsite':  return context.resources.strings.onsite;
      default:        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PrimaryText(
              text: context.resources.strings.jobType,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textColor: context.resources.color.colorGrey26,
            ),
            SizedBox(width: 4),
            PrimaryText(
              text: '*',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textColor: context.resources.color.colorGrey26,
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() {
          final selectedType = controller.selectedJobType.value;
          return SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _types.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final type = _types[index];
                final isSelected = selectedType == type;
                return GestureDetector(
                  onTap: () {
                    if (enabled) controller.selectJobType(type);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.resources.color.colorPrimary.withAlpha(16)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? context.resources.color.colorPrimary
                            : context.resources.color.colorGrey25,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: PrimaryText(
                        text: _label(context, type),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textColor: isSelected
                            ? context.resources.color.colorPrimary
                            : context.resources.color.colorBlack4,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
