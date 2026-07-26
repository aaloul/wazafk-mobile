import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

/// "Job Type *" — Project / One time chips (design p185), sent as `periodicity`.
class JobPeriodicityWidget extends StatelessWidget {
  const JobPeriodicityWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();
    final strings = context.resources.strings;

    final options = <String, String>{
      AddJobController.periodicityProject: strings.jobTypeProject,
      AddJobController.periodicityOneTime: strings.jobTypeOneTime,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: strings.jobType, isMandatory: true),
        const SizedBox(height: 8),
        Obx(() {
          final selected = controller.selectedPeriodicity.value;
          final entries = options.entries.toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final entry in entries) ...[
                  FormChoiceChip(
                    label: entry.value,
                    selected: selected == entry.key,
                    enabled: enabled,
                    minWidth: 80,
                    onTap: () => controller.selectPeriodicity(entry.key),
                  ),
                  if (entry != entries.last) const SizedBox(width: 6),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
